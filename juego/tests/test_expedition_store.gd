extends SceneTree

const Store = preload("res://scripts/expedition_store.gd")
const Rules = preload("res://scripts/expedition_rules.gd")
var checks := 0
var failures := 0
var integration_store := SandboxStore.new()
var seen_offers := {}

class SandboxStore extends "res://scripts/expedition_store.gd":
	func path() -> String:
		return "user://test_expedition_store.json"

class UnwritableStore extends "res://scripts/expedition_store.gd":
	func path() -> String:
		return "user://no_such_expedition_test_folder/slot.json"

func _initialize() -> void:
	call_deferred("run")

func check(condition: bool, message: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		push_error(message)

func fresh() -> Dictionary:
	return {"schema": 1, "mode": "roguelite", "sequence": 0, "campaign": {"wood": 0, "ore": 0, "patio": false, "mara": false, "boss": false, "botica": false, "arsenal": false, "class": "guardian", "kit": "normal", "weapon": "basic"}, "active_run": {}, "last_result": {}}

func fixture() -> Dictionary:
	var s := fresh()
	s.campaign.patio = true
	s.sequence = 1
	s.active_run = {"id": "test_1", "seed": 123, "node": "N1", "x": 2, "y": 6, "class": "guardian", "kit": "normal", "weapon": "basic", "hp": 38, "mp": 12, "potions": 2, "potion_heal": 22, "max_mp": 12, "bag": {"wood": 0, "ore": 0}, "upgrades": [], "visited": ["N0", "N1"], "cleared": ["N0"], "claimed": [], "offers": {}, "pending_offer": "", "battle": {}, "mara_contact": false}
	return s

func battle() -> Dictionary:
	return {"enemy": "slime", "hp": 14, "max_hp": 14, "turn": 0, "phase": 0, "phase_turn": 0, "guard": false, "burn_turns": 0, "focus": 0, "prepared": false, "message": "Elige tu accion."}

func cleanup() -> void:
	for suffix in ["", ".tmp", ".bak"]:
		var target: String = "user://test_expedition_store.json" + suffix
		if FileAccess.file_exists(target):
			DirAccess.remove_absolute(target)

func transition(state: Dictionary, action: String, value: String = "") -> Dictionary:
	Rules.command(state, action, value)
	var context := action + ":" + value + " " + str(state.active_run.get("node", "village"))
	check(Store.valid(state), "Real rules transition validates: " + context)
	if not Store.valid(state):
		push_error(JSON.stringify(state))
		return state
	check(integration_store.write(state), "Real transition writes: " + context)
	var loaded := integration_store.read()
	check(loaded == state, "Real transition survives read/write unchanged: " + context)
	return loaded if not loaded.is_empty() else state

func fight_real(state: Dictionary) -> Dictionary:
	state = transition(state, "interact", "enemy")
	var turns := 0
	while not state.active_run.is_empty() and not state.active_run.battle.is_empty() and turns < 80:
		var r: Dictionary = state.active_run
		var action := "attack"
		if r.hp <= 18 and r.potions > 0:
			action = "potion"
		elif Rules.intention(state).begins_with("Golpe pesado"):
			action = "defend"
		elif r["class"] == "mage" and r.mp >= Rules.stats(r).magic_cost:
			action = "magic"
		state = transition(state, action)
		turns += 1
	check(turns < 80, "Natural fight terminates within the turn budget")
	return state

func choose_real(state: Dictionary) -> Dictionary:
	if state.active_run.is_empty() or state.active_run.pending_offer.is_empty():
		return state
	var id: String = state.active_run.pending_offer
	seen_offers[id] = true
	var options := Rules.offer_options(state.active_run)
	check(not options.is_empty(), "Real pending reward has choices: " + id)
	return transition(state, "choose", options[0])

func integration() -> void:
	for cls in ["guardian", "assassin", "mage"]:
		for branch1 in ["N2A", "N2B"]:
			for branch2 in ["N4A", "N4B"]:
				var s := Rules.fresh()
				check(Store.valid(s), "Actual Rules.fresh validates")
				s = transition(s, "patio")
				s = transition(s, "class", cls)
				s = transition(s, "start")
				s = transition(s, "travel", "N1")
				s = fight_real(s)
				s = choose_real(s)
				s = transition(s, "interact", "chest")
				s = transition(s, "travel", branch1)
				if branch1 == "N2B":
					s = fight_real(s)
				else:
					s = transition(s, "interact", "event_wood")
				s = transition(s, "travel", "N3")
				if s.active_run.hp < 38:
					s = transition(s, "interact", "rest_hp")
				elif s.active_run.mp < s.active_run.max_mp:
					s = transition(s, "interact", "rest_mp")
				else:
					s = transition(s, "skip")
				s = transition(s, "travel", branch2)
				s = fight_real(s)
				if branch2 == "N4A":
					s = transition(s, "interact", "mara")
				else:
					s = choose_real(s)
				s = transition(s, "travel", "N5")
				s = transition(s, "interact", "alijo")
				s = choose_real(s)
				s = transition(s, "travel", "N6")
				s = fight_real(s)
				check(s.active_run.is_empty() and s.last_result.get("outcome") == "won", "All twelve real routes settle a saved victory")
				check(s.campaign.mara == (branch2 == "N4A"), "Saved rescue matches selected route")
				s = transition(s, "ack")
				s = transition(s, "build", "arsenal")
				s = transition(s, "weapon", "tactical")
				s = transition(s, "start")
				check(s.active_run.weapon == "tactical", "Saved project can prepare tactical weapon for another run")
				s = transition(s, "retreat")
				check(s.last_result.outcome == "retired", "Real retreat result saves")
	check(seen_offers.has("R1") and seen_offers.has("R2") and seen_offers.has("W1"), "Integration persisted every kind of reward offer")
	# Exercise a terminal defeat and the larger-mana reward through real commands.
	var s := Rules.fresh()
	s = transition(s, "patio")
	s = transition(s, "start")
	s = transition(s, "travel", "N1")
	s = transition(s, "interact", "enemy")
	s.active_run.variation.encounters.N1 = 0
	s.active_run.battle.variant = 0
	s.active_run.hp = 1
	s.active_run.bag = {"wood": 5, "ore": 4}
	s.active_run.battle.hp = 3
	s = transition(s, "defend")
	check(s.last_result.outcome == "lost" and s.last_result.lost_wood == 5 and s.last_result.lost_ore == 4, "Real simultaneous defeat saves full losses")
	var found_reserve := false
	for seed in range(30):
		s = Rules.fresh()
		Rules.command(s, "patio")
		Rules.command(s, "start")
		s.active_run.seed = seed
		Rules.command(s, "travel", "N1")
		s = fight_real(s)
		if Rules.offer_options(s.active_run).has("C03"):
			s = transition(s, "choose", "C03")
			check(s.active_run.max_mp == 15 and s.active_run.mp == 15, "Larger maximum mana persists after a genuine offer choice")
			found_reserve = true
			break
	check(found_reserve, "A deterministic reward fixture exercises C03")

func run() -> void:
	if not OS.get_cmdline_user_args().has("--test-mode"):
		push_error("Use -- --test-mode to protect player saves")
		quit(1)
		return
	cleanup()
	check(Store.valid(fresh()), "Fresh campaign validates")
	var s := fixture()
	check(Store.valid(s), "Exploration state validates")
	var loaded := Store.parse_text(JSON.stringify(s))
	check(not loaded.is_empty() and loaded == s, "JSON roundtrip preserves the complete expedition")
	check(loaded.active_run.hp is int and loaded.schema is int, "JSON integer fields normalize for engine commands")
	for text in ["bad", "[]", "null", "{}", "x".repeat(Store.LIMIT + 1)]:
		check(Store.parse_text(text).is_empty(), "Malformed, non-object or oversized data is rejected")
	var bad := s.duplicate(true)
	bad.active_run.x = 2.5
	check(not Store.valid(bad), "Fractional coordinates rejected")
	bad = s.duplicate(true)
	bad.active_run.x = 0
	check(not Store.valid(bad), "Outside playable rectangle rejected")
	bad = s.duplicate(true)
	bad.active_run.x = 6
	bad.active_run.y = 2
	check(not Store.valid(bad), "Position inside a map obstacle rejected")
	bad = s.duplicate(true)
	bad.active_run.upgrades = ["A01"]
	check(not Store.valid(bad), "Incompatible subclass upgrade rejected")
	bad = s.duplicate(true)
	bad.active_run.upgrades = ["G01", "G01"]
	check(not Store.valid(bad), "Duplicate unique upgrade rejected")
	bad = s.duplicate(true)
	bad.campaign.kit = "small"
	check(not Store.valid(bad), "Locked supply kit rejected")
	bad = s.duplicate(true)
	bad.active_run.pending_offer = "R1"
	check(not Store.valid(bad), "Pending reward requires persistent options")
	s.active_run.battle = battle()
	check(Store.valid(s), "Combat snapshot validates")
	bad = s.duplicate(true)
	bad.active_run.battle.enemy = "guardian"
	check(not Store.valid(bad), "Enemy must match current node")
	bad = s.duplicate(true)
	bad.active_run.battle.focus = 1.5
	check(not Store.valid(bad), "Combat counters must be integral")
	var store := SandboxStore.new()
	check(store.read().is_empty() and store.last_error.is_empty(), "No slot means a new campaign, not corruption")
	check(store.write(s), "A complete combat snapshot writes")
	check(store.read() == s, "Combat survives disk roundtrip")
	s.campaign.wood = 10
	check(store.write(s), "Second snapshot writes and preserves backup")
	var file := FileAccess.open(store.path(), FileAccess.WRITE)
	file.store_string("corrupted primary")
	file.close()
	var recovered := store.read()
	check(recovered.campaign.wood == 0 and not store.last_error.is_empty(), "Corrupt primary recovers last valid backup with notice")
	check(store.write(s), "Recovery can save without replacing backup with corruption")
	var backup := Store.parse_text(FileAccess.get_file_as_string(store.path() + ".bak"))
	check(backup.campaign.wood == 0, "Valid backup survives a write over corrupt primary")
	var before := FileAccess.get_file_as_string(store.path())
	check(not store.write(bad), "Invalid write refused")
	check(FileAccess.get_file_as_string(store.path()) == before, "Refused write leaves on-disk campaign untouched")
	var failing := UnwritableStore.new()
	check(not failing.write(s) and not failing.last_error.is_empty(), "Storage failure reports an error")
	s.active_run = {}
	s.last_result = {"id": "test_1", "outcome": "lost", "wood": 0, "ore": 0, "lost_wood": 8, "lost_ore": 6, "mara": false, "boss": false, "ack": false}
	check(Store.valid(s), "A pending terminal result persists after run is cleared")
	bad = s.duplicate(true)
	bad.last_result.wood = 1
	check(not Store.valid(bad), "Defeat cannot claim carried resources")
	integration()
	cleanup()
	print("EXPEDITION STORE TESTS: %d checks, %d failures" % [checks, failures])
	quit(0 if failures == 0 else 1)
