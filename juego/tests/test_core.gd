extends SceneTree

const Economy = preload("res://scripts/economy.gd")
const Combat = preload("res://scripts/combat.gd")
const Store = preload("res://scripts/save_store.gd")
const Regions = preload("res://scripts/regions.gd")
const State = preload("res://scripts/game.gd")
var checks := 0
var failures: Array[String] = []

func _initialize() -> void:
	call_deferred("run")

func check(condition: bool, description: String) -> void:
	checks += 1
	if not condition:
		failures.append(description)
		push_error(description)

func run() -> void:
	var store := Store.new()
	var s: Dictionary = State.fresh()
	check(Store.valid(s), "Fresh state is valid")
	# Fractional online intervals and one offline interval must agree.
	s.flags.mine_open = true
	s.flags.forge_repaired = true
	s.workers.mara = true
	s.workers.ivo = true
	var online: Dictionary = s.duplicate(true)
	var offline: Dictionary = s.duplicate(true)
	for i in range(240):
		Economy.advance(online, 0.25)
	Economy.advance(offline, 60.0)
	check(online.resources == offline.resources and online.production == offline.production, "Online and offline production agree")
	check(offline.resources.ingot == 5 and offline.resources.ore == 2, "Production respects mining intervals and forge inputs")
	var future: Dictionary = State.fresh()
	var gains: Dictionary = Economy.advance(future, -500.0)
	check(gains.seconds == 0 and future.resources.ore == 0, "Negative time cannot produce resources")
	var capped: Dictionary = s.duplicate(true)
	check(Economy.advance(capped, 999999.0).seconds == 28800, "Offline time is capped at eight hours")
	# Save loss/victory screens, not just player attributes.
	var enemy: Resource = load("res://data/guardian.tres")
	s.flags.sword = true
	s.battle = Combat.create(enemy,"mine_guardian")
	s.hp = 1
	Combat.act(s,"attack",enemy)
	check(s.battle.status == "lost" and s.hp == 0, "Defeat is an explicit persistent state")
	var gold_after_loss: int = s.resources.gold
	check(store.write(s,"user://test_core.json"), "Defeat save writes")
	var recovered := store.read("user://test_core.json")
	check(recovered.hp == 0 and recovered.battle.status == "lost", "Defeat result survives load")
	Combat.act(recovered,"attack",enemy)
	check(recovered.resources.gold == gold_after_loss, "Resolving an already finished battle cannot repeat the loss penalty")
	s = State.fresh()
	s.flags.sword = true
	s.battle = Combat.create(enemy,"mine_guardian")
	s.battle.hp = 1
	Combat.act(s,"attack",enemy)
	var won_gold: int = s.resources.gold
	check(s.flags.boss_defeated and s.battle.status == "won", "Boss victory applies its flag")
	check(store.write(s,"user://test_core.json"), "Victory save writes")
	recovered = store.read("user://test_core.json")
	check(recovered.battle.status == "won" and recovered.flags.boss_defeated, "Victory result survives load")
	Combat.act(recovered,"attack",enemy)
	check(recovered.resources.gold == won_gold, "Victory cannot pay twice")
	# A damaged main slot recovers the last valid backup.
	check(store.write(s,"user://test_core.json"), "Valid backup created")
	var broken := FileAccess.open("user://test_core.json",FileAccess.WRITE)
	broken.store_string("{damaged")
	broken.close()
	recovered = store.read("user://test_core.json")
	check(not recovered.is_empty() and not store.last_error.is_empty(), "Corrupt save recovers backup with an explanation")
	var invalid: Dictionary = s.duplicate(true)
	invalid.production.remainder = -1
	check(not Store.valid(invalid), "Invalid production data is rejected")
	invalid = s.duplicate(true)
	invalid.schema = 999
	check(not Store.valid(invalid), "Unknown save schema is rejected")
	# Validate reachability of every interaction in each hand-authored region.
	for region in ["village","forest","mine"]:
		var reached := reachable(region,Vector2i(11,12) if region == "village" else Vector2i(2,8))
		for obj in Regions.objects(region):
			var accessible := reached.has(obj.at)
			for direction in [Vector2i.UP,Vector2i.DOWN,Vector2i.LEFT,Vector2i.RIGHT]:
				accessible = accessible or reached.has(obj.at + direction)
			check(accessible,"Reachable interaction: " + region + "/" + obj.id)
	# Play through the core economic/quest chain using the actual services.
	var game: Node = root.get_node("Game")
	var original: Dictionary = game.state.duplicate(true)
	var original_blocked: bool = game.save_blocked
	game.save_blocked = true # tests must never replace the player's slot
	game.state = State.fresh()
	game.start_battle("wolf","forest_wolf")
	game.state.battle.hp = 1
	game.battle_action("attack")
	game.finish_battle()
	game.interact("forge")
	game.interact("mara")
	game.interact("ivo")
	Economy.advance(game.state,60)
	game.interact("forge")
	check(game.state.flags.sword and game.state.resources.ingot == 2,"Mine, helpers and forging form a complete chain")
	game.start_battle("guardian","mine_guardian")
	game.state.battle.hp = 1
	game.battle_action("attack")
	game.finish_battle()
	game.interact("beacon")
	check(game.state.flags.beacon and game.state.resources.ingot == 0,"Boss victory unlocks the permanent village improvement")
	# Complete unmodified fights using a simple strategy, without setting enemy HP.
	for type in ["slime","wolf","bat","guardian"]:
		var fighter: Dictionary = State.fresh()
		fighter.flags.sword = type == "guardian"
		var foe: Resource = load("res://data/" + type + ".tres")
		fighter.battle = Combat.create(foe,"balance_test_" + type)
		var turns := 0
		while fighter.battle.status == "fighting" and turns < 100:
			var action := "attack"
			if int(fighter.battle.turn) % 3 == 2:
				action = "defend"
			elif fighter.hp <= 20 and fighter.potions > 0:
				action = "potion"
			elif fighter.mp >= 4:
				action = "magic"
			Combat.act(fighter,action,foe)
			turns += 1
		check(fighter.battle.status == "won","Natural combat is winnable: " + type)
	# Selling renewable ore keeps the repair affordable even after repeated defeats.
	game.state = State.fresh()
	game.state.flags.mine_open = true
	game.state.resources.gold = 0
	game.state.resources.ore = 4
	for i in range(4):
		game.interact("sell_ore")
	game.interact("forge")
	check(game.state.flags.forge_repaired,"Repair cannot softlock when renewable ore is available")
	game.state = original
	game.save_blocked = original_blocked
	# Only remove explicitly named test artifacts, never a real slot.
	for suffix in ["", ".bak", ".tmp"]:
		var path: String = "user://test_core.json" + suffix
		if FileAccess.file_exists(path):
			DirAccess.remove_absolute(path)
	print("CORE TESTS: %d checks, %d failures" % [checks,failures.size()])
	quit(0 if failures.is_empty() else 1)

func reachable(region: String, start: Vector2i) -> Dictionary:
	var seen := {start: true}
	var queue: Array[Vector2i] = [start]
	while not queue.is_empty():
		var at: Vector2i = queue.pop_front()
		for direction in [Vector2i.UP,Vector2i.DOWN,Vector2i.LEFT,Vector2i.RIGHT]:
			var next: Vector2i = at + direction
			if not seen.has(next) and Regions.walkable(region,next,[]):
				seen[next] = true
				queue.append(next)
	return seen
