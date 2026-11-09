extends SceneTree

const State = preload("res://scripts/game.gd")
const Builds = preload("res://scripts/build_rules.gd")
const Combat = preload("res://scripts/combat.gd")
const Store = preload("res://scripts/save_store.gd")
var checks := 0
var failures := 0

func _initialize() -> void:
	call_deferred("run")

func check(condition: bool, text: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		push_error(text)

func fighter(style: String, talent: String) -> Dictionary:
	var s: Dictionary = State.fresh()
	s.flags.sword = true
	s.flags.boss_defeated = true
	s.active_style = style
	s.loadouts = Builds.defaults(true)
	s.loadouts[style].talent = talent
	s.battle = Combat.create(load("res://data/guardian.tres"), "mine_guardian")
	return s

func run() -> void:
	var enemy: Resource = load("res://data/guardian.tres")
	var store := Store.new()
	var s := fighter("guardian", "reprisal")
	Combat.act(s,"defend",enemy)
	check(s.battle.hp == 58 and s.hp == 36,"Reprisal reflects six after the reduced enemy hit")
	s = fighter("guardian","renewal")
	s.hp = 20
	Combat.act(s,"defend",enemy)
	check(s.hp == 21 and s.battle.hp == 61,"Renewal heals three and retains the base reflection")
	s.mp = 0
	s.loadouts.guardian.relic = "sap_seal"
	Combat.act(s,"defend",enemy)
	check(s.mp == 4,"Sap seal modifies mana gained on guard")
	s = fighter("mage","embers")
	s.loadouts.mage.relic = "ember_charm"
	Combat.act(s,"magic",enemy)
	check(s.battle.hp == 45 and s.battle.burn_turns == 4 and s.mp == 8,"Mage, staff, talent and relic compose into an extended burn")
	Combat.act(s,"defend",enemy)
	check(s.battle.hp == 43 and s.battle.burn_turns == 3,"Burn ticks on the following valid action")
	s.mp = 0
	var before: Dictionary = s.duplicate(true)
	Combat.act(s,"magic",enemy)
	check(s.battle.hp == before.battle.hp and s.battle.burn_turns == before.battle.burn_turns and s.battle.turn == before.battle.turn,"Unavailable actions do not advance burn or the enemy turn")
	s = fighter("mage","channeling")
	Combat.act(s,"magic",enemy)
	check(s.mp == 9 and s.battle.burn_turns == 2,"Channeling lowers mana cost and forgoes the extra talent duration")
	s = fighter("ranger","precision")
	Combat.act(s,"attack",enemy)
	check(s.battle.hp == 56 and s.battle.focus == 1,"First ranger attack prepares the next critical")
	Combat.act(s,"attack",enemy)
	check(s.battle.hp == 32 and s.battle.focus == 0,"Second precision attack uses the bow critical multiplier")
	s = fighter("ranger","mobility")
	Combat.act(s,"attack",enemy)
	check(s.hp == 32 and s.battle.focus == 1,"Mobility reduces incoming damage on an attack")
	check(Builds.stats(s).critical_interval == 3,"Mobility keeps the three-attack critical interval")
	for style in Builds.STYLES:
		for talent in Builds.STYLES[style].talents:
			var natural := fighter(style, talent)
			var turns := 0
			while natural.battle.status == "fighting" and turns < 100:
				var action := "attack"
				if int(natural.battle.turn) % 3 == 2:
					action = "defend"
				elif natural.hp <= 20 and natural.potions > 0:
					action = "potion"
				elif style == "mage" and natural.mp >= Builds.stats(natural).magic_cost:
					action = "magic"
				Combat.act(natural, action, enemy)
				turns += 1
			check(natural.battle.status == "won", "Guardian is winnable with " + style + "/" + talent)
	# Save and recover combat counters and selected gear.
	check(store.write(s,"user://test_builds.json"),"A configured battle saves")
	var recovered := store.read("user://test_builds.json")
	check(recovered.active_style == "ranger" and recovered.battle.focus == 1 and recovered.loadouts == s.loadouts,"Build and critical counter survive disk loading")
	var legacy: Dictionary = State.fresh()
	legacy.schema = 1
	legacy.erase("active_style")
	legacy.erase("loadouts")
	legacy.flags = {"mine_open": true,"forge_repaired": true,"sword": true,"boss_defeated": true,"beacon": true}
	legacy.resources = {"gold":137,"wood":6,"ore":17,"ingot":8}
	legacy.defeated = ["forest_wolf","mine_guardian"]
	check(Store.valid(legacy),"A completed original 0.1 save is accepted")
	var migrated := Store.normalize(legacy)
	check(migrated.schema == 2 and migrated.flags == legacy.flags and migrated.resources == legacy.resources and migrated.defeated == legacy.defeated,"Migration preserves the restored village, resources and kills")
	check(migrated.loadouts.guardian.weapon == "valley_blade" and migrated.loadouts.mage.weapon == "ember_staff", "Migration grants gear corresponding to the already forged sword")
	check(Store.valid(Store.parse_text(JSON.stringify(migrated))),"Schema two validates after JSON roundtrip")
	check(store.write(legacy,"user://test_legacy.json"),"An original save can be prepared for migration")
	var migrated_disk := store.read("user://test_legacy.json")
	check(migrated_disk.schema == 2 and FileAccess.file_exists("user://test_legacy.json.before-schema2.json"),"First migration preserves a separate original snapshot")
	legacy.resources.gold = 200
	store.write(legacy,"user://test_legacy.json")
	store.read("user://test_legacy.json")
	var snapshot: Variant = Store.parse_text(FileAccess.get_file_as_string("user://test_legacy.json.before-schema2.json"))
	check(snapshot.resources.gold == 137,"Subsequent reads do not replace the original pre-migration snapshot")
	legacy.hp = 0
	legacy.battle = {"enemy":"wolf","instance":"forest_wolf","hp":18,"turn":1,"status":"lost","message":"Derrota pendiente"}
	migrated = Store.normalize(legacy)
	check(Store.valid(migrated) and migrated.battle.status == "lost" and migrated.hp == 0,"A pending old defeat migrates without resolving or charging again")
	var invalid: Dictionary = migrated.duplicate(true)
	invalid.loadouts.guardian.weapon = "unknown_item"
	check(not Store.valid(invalid),"Unknown gear is rejected")
	invalid = migrated.duplicate(true)
	invalid.x = 3.5
	check(not Store.valid(invalid),"Fractional map coordinates are rejected")
	invalid = migrated.duplicate(true)
	invalid.x = 4
	invalid.y = 3
	check(not Store.valid(invalid),"Positions inside the forge are rejected")
	var game: Node = root.get_node("Game")
	check(game.save_blocked,"The test process is isolated from the player slot")
	game.state = State.fresh()
	check(not game.configure_character("mage","weapon","ember_staff"),"Locked gear cannot be equipped")
	game.state.flags.sword = true
	game.state.loadouts = Builds.defaults(true)
	check(game.configure_character("mage","talent","channeling"),"Talents can be switched in the village")
	check(game.configure_character("guardian") and game.configure_character("mage"),"Styles can be freely switched in the village")
	check(game.state.loadouts.mage.talent == "channeling","Returning to a style restores its configuration")
	game.state.region = "forest"
	check(not game.configure_character("ranger"),"Characters cannot be reconfigured in the field")
	game.state.region = "village"
	check(not game.start_practice("guardian"),"Boss practice is locked before its story victory")
	game.state.flags.boss_defeated = true
	game.state.hp = 17
	game.state.mp = 5
	game.state.potions = 1
	var saved_flags: Dictionary = game.state.flags.duplicate()
	var saved_resources: Dictionary = game.state.resources.duplicate()
	check(game.start_practice("wolf"),"Practice starts in the village")
	check(game.state.hp == 38 and game.state.mp == 12 and game.state.potions == 3,"Practice lends fresh combat supplies")
	game.state.battle.hp = 1
	game.battle_action("magic")
	check(game.state.defeated.is_empty() and game.state.flags == saved_flags and game.state.resources == saved_resources,"Practice victory never pays or unlocks the story")
	game.finish_battle()
	check(game.state.hp == 17 and game.state.mp == 5 and game.state.potions == 1,"Practice restores the original supplies")
	game.start_practice("guardian")
	game.state.hp = 1
	game.battle_action("attack")
	check(game.state.resources == saved_resources and game.state.battle.status == "lost","Practice defeat cannot charge coins")
	check(store.write(game.state,"user://test_builds.json"),"Pending practice defeat saves")
	game.state = store.read("user://test_builds.json")
	game.finish_battle()
	check(game.state.hp == 17 and game.state.mp == 5 and game.state.potions == 1,"Reloaded practice defeat restores original supplies exactly once")
	check(game.state.battle.is_empty(),"Resolved practice clears its pending state")
	for suffix in ["", ".bak", ".tmp"]:
		var path: String = "user://test_builds.json" + suffix
		if FileAccess.file_exists(path):
			DirAccess.remove_absolute(path)
	for suffix in ["", ".bak", ".tmp", ".before-schema2.json"]:
		var path: String = "user://test_legacy.json" + suffix
		if FileAccess.file_exists(path):
			DirAccess.remove_absolute(path)
	print("BUILD TESTS: %d checks, %d failures" % [checks,failures])
	quit(0 if failures == 0 else 1)
