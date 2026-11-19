extends SceneTree

const Rules = preload("res://scripts/expedition_rules.gd")
var checks := 0
var failures := 0

func _initialize() -> void:
	call_deferred("run")

func check(ok: bool, description: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error(description)

func start(cls: String = "guardian") -> Dictionary:
	var s := Rules.fresh()
	Rules.command(s, "patio")
	Rules.command(s, "class", cls)
	Rules.command(s, "start")
	# Preserve the original encounter contract in the 0.3 regression suite.
	for node in s.active_run.variation.encounters: s.active_run.variation.encounters[node] = 0
	return s

func battle(s: Dictionary, strategy: int = 0) -> bool:
	Rules.command(s, "interact", "enemy")
	var turns := 0
	while not s.active_run.is_empty() and not s.active_run.battle.is_empty() and turns < 80:
		var r: Dictionary = s.active_run
		var action := "attack"
		if r.hp <= 18 and r.potions > 0:
			action = "potion"
		elif Rules.intention(s).begins_with("Golpe pesado"):
			action = "defend"
		elif r["class"] == "mage" and r.mp >= Rules.stats(r).magic_cost:
			action = "magic"
		elif strategy == 1 and r["class"] == "guardian" and Rules.intention(s).begins_with("Golpe"):
			action = "defend" if turns % 2 == 0 else "attack"
		Rules.command(s, action)
		turns += 1
	return turns < 80 and (not s.active_run.is_empty() or s.last_result.get("outcome") == "won")

func resolve_offer(s: Dictionary, strategy: int = 0) -> void:
	if s.active_run.is_empty():
		return
	var options := Rules.offer_options(s.active_run)
	if not options.is_empty():
		Rules.command(s, "choose", options[0 if strategy == 0 else options.size() - 1])

func full_run(cls: String, branch1: String, branch2: String, strategy: int) -> Dictionary:
	var s := start(cls)
	Rules.command(s, "travel", "N1")
	check(battle(s, strategy), "Initial slime is beatable for " + cls)
	resolve_offer(s, strategy)
	Rules.command(s, "travel", branch1)
	if branch1 == "N2B":
		check(battle(s, strategy), "Wolf route beatable " + cls)
	else:
		Rules.command(s, "interact", "event_wood")
	Rules.command(s, "travel", "N3")
	if s.active_run.hp < 38:
		Rules.command(s, "interact", "rest_hp")
	elif s.active_run.mp < s.active_run.max_mp:
		Rules.command(s, "interact", "rest_mp")
	else:
		Rules.command(s, "skip")
	Rules.command(s, "travel", branch2)
	check(battle(s, strategy), "Second branch beatable " + cls + branch2)
	if branch2 == "N4A":
		Rules.command(s, "interact", "mara")
	resolve_offer(s, strategy)
	Rules.command(s, "travel", "N5")
	Rules.command(s, "interact", "alijo")
	resolve_offer(s, strategy)
	Rules.command(s, "travel", "N6")
	check(battle(s, strategy), "Boss beatable " + cls)
	return s

func run() -> void:
	var s := start()
	check(s.campaign.wood == 0 and s.active_run.potions == 2 and s.active_run.upgrades.is_empty(), "Free initial supplies without old talents")
	var before: Dictionary = s.duplicate(true)
	Rules.command(s, "travel", "N4B")
	check(s == before, "Invalid graph jump changes nothing")
	Rules.command(s, "travel", "N1")
	Rules.command(s, "retreat")
	check(not s.active_run.is_empty(), "Cannot retreat before clearing encounter")
	Rules.command(s, "interact", "enemy")
	s.active_run.mp = 0
	before = s.duplicate(true)
	Rules.command(s, "magic")
	check(s == before, "Invalid magic does not advance enemy or effects")
	Rules.command(s, "potion")
	check(s == before, "Full-health potion does not consume resource or turn")
	Rules.command(s, "flee")
	check(s == before, "No free combat escape")
	check(battle_existing(s), "Fight can resume after invalid action")
	var offer_before := Rules.offer_options(s.active_run)
	s = JSON.parse_string(JSON.stringify(s))
	check(Rules.offer_options(s.active_run) == offer_before, "Serialized reward choices remain identical")
	Rules.command(s, "choose", "M01")
	check(Rules.offer_options(s.active_run) == offer_before, "Foreign specialization cannot be selected")
	resolve_offer(s)
	Rules.command(s, "interact", "chest")
	Rules.command(s, "interact", "chest")
	check(s.active_run.bag.wood == 3, "Cofre and combat rewards cannot duplicate")
	Rules.command(s, "retreat")
	check(s.campaign.wood == 3 and s.last_result.wood == 3, "Retreat deposits complete bag")
	Rules.command(s, "retreat")
	check(s.campaign.wood == 3, "Repeated finish cannot pay twice")
	Rules.command(s, "ack")
	Rules.command(s, "start")
	check(s.active_run.bag.wood == 0 and s.active_run.upgrades.is_empty(), "New run resets all temporary rewards")

	# Simultaneous death keeps the bank and loses the whole bag, including pending rescue.
	s = start()
	s.campaign.wood = 7
	s.active_run.bag = {"wood": 5, "ore": 4}
	s.active_run.mara_contact = true
	Rules.command(s, "travel", "N1")
	Rules.command(s, "interact", "enemy")
	s.active_run.hp = 1
	s.active_run.battle.hp = 3
	Rules.command(s, "defend")
	check(s.active_run.is_empty() and s.last_result.outcome == "lost", "Both dying is defeat")
	check(s.campaign.wood == 7 and s.campaign.ore == 0 and not s.campaign.mara, "Defeat keeps bank, loses materials and pending rescue")
	check(s.last_result.lost_wood == 5 and s.last_result.lost_ore == 4, "Defeat summary lists full losses")

	# Guardian counter only reacts to an actual hit, not preparations.
	s = start()
	Rules.command(s, "travel", "N1")
	Rules.command(s, "interact", "enemy")
	Rules.command(s, "defend")
	var enemy_hp: int = s.active_run.battle.hp
	Rules.command(s, "defend")
	check(s.active_run.battle.hp == enemy_hp, "No counterattack on non-damaging enemy preparation")

	for cls in Rules.CLASSES:
		for branch1 in ["N2A", "N2B"]:
			for branch2 in ["N4A", "N4B"]:
				for strategy in [0, 1]:
					s = full_run(cls, branch1, branch2, strategy)
					check(s.active_run.is_empty() and s.last_result.outcome == "won", "Complete route wins " + cls + branch1 + branch2 + str(strategy))
					check(s.campaign.boss and s.campaign.mara == (branch2 == "N4A"), "Unique boss and rescue settled")
					if branch1 == "N2A" and branch2 == "N4A":
						check(s.campaign.wood == 10 and s.campaign.ore == 6, "Safe route with herbs returns ten wood and six ore")
						Rules.command(s, "build", "arsenal")
						check(s.campaign.arsenal and s.campaign.wood == 2 and s.campaign.ore == 0, "Equipment bank consumes exact costs")
						before = s.duplicate(true)
						Rules.command(s, "build", "arsenal")
						check(s == before, "Duplicate building does not charge twice")
	print("EXPEDITION: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)

func battle_existing(s: Dictionary) -> bool:
	var steps := 0
	while not s.active_run.is_empty() and not s.active_run.battle.is_empty() and steps < 50:
		Rules.command(s, "defend" if Rules.intention(s).begins_with("Golpe pesado") else "attack")
		steps += 1
	return not s.active_run.is_empty() and s.active_run.battle.is_empty()
