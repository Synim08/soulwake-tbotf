extends SceneTree

const Store = preload("res://scripts/save_store.gd")
const State = preload("res://scripts/game.gd")
const Economy = preload("res://scripts/economy.gd")
var checks := 0
var failures := 0

class SandboxStore extends ValleySaveStore:
	func write(value: Dictionary, _path: String = SLOT) -> bool:
		return super.write(value, "user://test_persistence.json")

class FailingStore extends ValleySaveStore:
	func write(_value: Dictionary, _path: String = SLOT) -> bool:
		last_error = "Fallo de escritura simulado."
		return false

func _initialize() -> void:
	call_deferred("run")

func check(condition: bool, text: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		push_error(text)

func run() -> void:
	var game: Node = root.get_node("Game")
	check(game.save_blocked, "Run with -- --test-mode to isolate the real player slot")
	if not game.save_blocked:
		quit(1)
		return
	game.store = SandboxStore.new()
	var fixture: Dictionary = State.fresh()
	fixture.resources = {"gold": 137, "wood": 6, "ore": 17, "ingot": 8}
	fixture.flags = {"mine_open": true, "forge_repaired": true, "sword": true, "boss_defeated": true, "beacon": true}
	fixture.defeated = ["forest_wolf", "mine_guardian"]
	check(game.import_text(JSON.stringify(fixture)), "A valid import commits")
	var saved: Dictionary = game.store.read("user://test_persistence.json")
	check(saved.resources == fixture.resources and saved.flags == fixture.flags and saved.defeated == fixture.defeated, "Imported progress survives a real disk roundtrip")
	var original: Dictionary = game.state.duplicate(true)
	check(not game.import_text("not JSON"), "Invalid JSON is rejected")
	check(game.state == original, "Invalid input preserves the active session")
	game.store = FailingStore.new()
	fixture.resources.gold = 999
	check(not game.import_text(JSON.stringify(fixture)), "Import reports a storage failure")
	check(game.state == original, "A failed storage write never replaces the session")
	game.store = SandboxStore.new()
	# A fixed timestamp makes double settlement detectable without waiting.
	game.state = State.fresh()
	game.state.flags.mine_open = true
	game.state.workers.mara = true
	game.state.last_time = Time.get_unix_time_from_system() - 60.0
	game.settle()
	check(game.state.resources.ore == 12, "A one-minute absence pays twelve ore")
	game.persist()
	game.state = game.store.read("user://test_persistence.json")
	game.settle()
	check(game.state.resources.ore == 12, "Reloading a settled save does not pay the absence again")
	var negative: Dictionary = game.state.duplicate(true)
	negative.last_time = Time.get_unix_time_from_system() + 5000
	game.state = negative
	game.settle()
	check(game.state.resources.ore == 12, "A future timestamp does not create resources")
	var capped: Dictionary = State.fresh()
	capped.flags.mine_open = true
	capped.workers.mara = true
	Economy.advance(capped, 99999999)
	check(capped.resources.ore == 5760, "The eight-hour cap applies to long absences")
	game.save_blocked = true
	for suffix in ["", ".tmp", ".bak"]:
		var path: String = "user://test_persistence.json" + suffix
		if FileAccess.file_exists(path):
			DirAccess.remove_absolute(path)
	print("PERSISTENCE TESTS: %d checks, %d failures" % [checks, failures])
	quit(0 if failures == 0 else 1)
