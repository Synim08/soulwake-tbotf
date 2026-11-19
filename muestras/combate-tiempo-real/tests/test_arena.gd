extends SceneTree

const Arena = preload("res://arena.tscn")
const Store = preload("res://run_store.gd")
var checks := 0
var failures := 0
var arena

func _initialize() -> void:
	call_deferred("run")

func check(condition: bool, detail: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		push_error(detail)

func run() -> void:
	arena = Arena.instantiate()
	root.add_child(arena)
	arena.set_physics_process(false)
	check(not arena.save_enabled, "The test cannot write to the prototype slot")
	check(arena.player == arena.ENTRANCE, "New run starts at the entrance")

	arena.player = Vector2(442,319)
	arena.attack_direction = Vector2.RIGHT
	arena.combat.potions = 0
	arena.enemies[0].position = Vector2(676,319)
	check(arena._slide(arena.player, Vector2(60,0), arena.PLAYER_RADIUS) == arena.player, "Intact trunk blocks movement")
	arena.attack_heavy = false
	arena._resolve_attack()
	check(not arena.trunk_broken and arena.combat.charge == 0, "Misses and light hits against the trunk cannot charge a potion")
	arena.attack_heavy = true
	arena._resolve_attack()
	check(arena.trunk_broken and arena._slide(arena.player, Vector2(60,0), arena.PLAYER_RADIUS).x == 502 and arena.combat.charge == 0, "Heavy attack opens a path without giving a potion charge")

	arena.enemies[0].position = Vector2(503,309)
	arena.enemies[1].position = Vector2(514,330)
	arena.attack_heavy = false
	arena._resolve_attack()
	check(arena.enemies[0].hp == 36 and arena.enemies[1].hp == 46 and arena.combat.charge == 1, "One swing hitting two enemies charges the potion once")
	for index in 3:
		arena._resolve_attack()
	check(arena.combat.potions == 1 and arena.combat.charge == 0 and arena.combat.defeated == [0], "Four damaging attacks restore a potion, and only the defeated slime is cleared")
	arena.combat.hp = 29
	arena.combat.stamina = 5
	check(arena.combat.drink(), "Drinking is available below the stamina cost of an attack")
	arena.combat.hp = 22
	arena.combat.charge = 2

	var snapshot: Dictionary = arena.combat.snapshot()
	# Isolate the physical save using a path unique to this process's test.
	var disk := Store.new()
	disk.slot = "user://test_real_combat_%d.json" % OS.get_process_id()
	check(disk.write(snapshot, true, false, true), "Save can write the actual snapshot")
	var data: Dictionary = disk.candidates()[0] if not disk.candidates().is_empty() else {}
	check(not data.is_empty() and arena.combat.restore(data.get("combat", {}),2), "Snapshot survives JSON roundtrip")
	arena._reset_positions()
	check(arena.player == arena.ENTRANCE and arena.combat.hp == 22 and arena.combat.stamina == 5 and arena.combat.potions == 0 and arena.combat.charge == 2, "Reload moves player to entrance and preserves health and resources")
	check(arena.combat.defeated == [0] and arena.enemies[1].hp == 58 and data.get("broken_trunk") == true, "Reload keeps defeated enemies and trunk state while healing the survivor")
	arena.player = Vector2(410,390)
	arena.enemies[1].position = Vector2(520,390)
	arena.enemies[1].phase = "chase"
	arena._step_enemies(1.0/60)
	check(arena.enemies[1].phase == "tell", "Slime announces its leap during exploration")
	var marked: Vector2 = arena.enemies[1].target
	arena.player += Vector2(0,75)
	arena._step_enemies(0.2)
	check(arena.enemies[1].target == marked, "The telegraph holds its position when the player sidesteps")
	arena.enemies[1].time = 0.001
	arena._step_enemies(0.016)
	arena.enemies[1].time = 0.001
	arena._step_enemies(0.016)
	check(arena.combat.hp == 22, "Moving out of the circle avoids the impact")
	arena.player = arena.enemies[1].position
	arena.aim = arena.player.direction_to(arena.enemies[1].from)
	arena.guarding = true
	arena._enemy_impact(1)
	check(arena.combat.guard_break > 0 and arena.combat.hp == 10 and arena.combat.stamina == 0, "Strong impact breaks an underfunded frontal guard and applies damage")
	arena.combat.tick(1)
	arena.guarding = false
	arena.player = arena.enemies[1].position
	arena._enemy_impact(1)
	check(arena.combat.hp == 0 and arena.combat.status == "lost", "Fatal impact resolves defeat immediately")
	check(disk.write(arena.combat.snapshot(), true, false, true) and disk.candidates()[0].combat.status == "lost", "Defeat is the most recent valid saved result")
	for suffix in ["", ".bak", ".tmp"]:
		if FileAccess.file_exists(disk.slot + suffix):
			DirAccess.remove_absolute(disk.slot + suffix)

	arena.restart()
	arena.set_physics_process(false)
	arena.player = Vector2(240,410)
	arena.enemies[0].position = Vector2(325,410)
	arena.enemies[1].position = Vector2(360,450)
	for enemy in arena.enemies: enemy.phase = "chase"
	arena._step_enemies(1.0/60)
	check(arena.enemies[0].phase == "tell" and arena.enemies[1].phase == "chase", "Only one landing attack is announced at a time")
	arena.enemies[0].phase = "chase"
	arena._step_enemies(1.0/60)
	check(arena.enemies[1].phase == "tell" and arena.enemies[0].phase == "chase", "The second slime can take its turn even when both are ready")
	arena.attack_direction = Vector2.RIGHT
	arena.attack_heavy = true
	arena.enemies[0].hp = 12
	arena.enemies[1].hp = 12
	arena._resolve_attack()
	check(arena.combat.status == "active" and arena.combat.defeated == [0], "An enemy outside the swing does not die")
	arena.player = Vector2(310,447)
	arena._resolve_attack()
	check(arena.combat.status == "won" and arena.combat.defeated == [0,1], "Defeating both slimes resolves the encounter")
	print("Realtime arena: %d checks, %d failures" % [checks, failures])
	quit(0 if failures == 0 else 1)
