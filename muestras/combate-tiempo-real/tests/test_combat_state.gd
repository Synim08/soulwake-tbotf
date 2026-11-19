extends SceneTree

const CombatState = preload("../combat_state.gd")

var _checks := 0
var _failures := 0

func _initialize() -> void:
	call_deferred("_run")

func _check(condition: bool, detail: String) -> void:
	_checks += 1
	if not condition:
		_failures += 1
		push_error(detail)

func _run() -> void:
	_attacks_and_recovery()
	_guard_and_damage()
	_potion_recharge()
	_save_and_end_states()
	print("Combate en tiempo real: %d comprobaciones, %d fallos." % [_checks, _failures])
	quit(1 if _failures else 0)

func _attacks_and_recovery() -> void:
	var state := CombatState.new()
	_check(state.spend_attack(false) and state.stamina == CombatState.STAMINA_MAX - CombatState.LIGHT_COST,
		"El ataque normal consume estamina.")
	var after_light := state.stamina
	_check(state.spend_attack(true) and state.stamina == after_light - CombatState.HEAVY_COST and CombatState.HEAVY_COST > CombatState.LIGHT_COST,
		"El ataque pesado consume más estamina.")
	state.stamina = 1.0
	_check(not state.spend_attack(false) and not state.spend_attack(true) and state.stamina == 1.0,
		"Un ataque sin estamina suficiente no descuenta nada.")
	state.tick(CombatState.STAMINA_DELAY / 2)
	_check(state.stamina == 1.0, "La regeneración espera tras gastar estamina.")
	state.tick(CombatState.STAMINA_DELAY + 1.0, true)
	_check(state.stamina == 1.0, "La regeneración se detiene al mantener el bloqueo.")
	state.tick(0.1)
	_check(is_equal_approx(state.stamina, 1.0 + CombatState.STAMINA_RECOVERY * 0.1),
		"La estamina vuelve al soltar el bloqueo.")
	state.tick(10.0)
	_check(state.stamina == CombatState.STAMINA_MAX, "La regeneración respeta el máximo.")

func _guard_and_damage() -> void:
	var state := CombatState.new()
	var hit: Dictionary = state.receive_hit(12, 18.0, true)
	_check(hit.blocked and not hit.broken and hit.damage == 3 and state.stamina == CombatState.STAMINA_MAX - 18.0,
		"Un bloqueo pagado reduce daño y descuenta el coste del impacto.")
	var after_hit := state.snapshot()
	_check(state.receive_hit(12, 25.0, true).ignored and state.snapshot() == after_hit,
		"La protección breve evita daño y costes adicionales.")
	state.tick(CombatState.HURT_PROTECTION)
	hit = state.receive_hit(12, 35.0, true)
	_check(hit.blocked and state.stamina == CombatState.STAMINA_MAX - 18.0 - 35.0,
		"Un impacto más exigente cuesta más estamina aunque quite la misma vida.")
	state.tick(CombatState.HURT_PROTECTION)
	state.stamina = 4.0
	hit = state.receive_hit(12, 20.0, true)
	_check(hit.broken and not hit.blocked and hit.damage == 12 and state.stamina == 0.0 and state.guard_break > 0.0,
		"Un impacto que supera la estamina rompe la guardia y hace daño completo.")
	_check(not state.can_block() and not state.spend_attack(false), "La ruptura impide bloquear y atacar.")
	_check(state.drink() and state.hp == CombatState.HEALTH_MAX and state.stamina == 0.0,
		"La poción cura de inmediato incluso durante la ruptura y sin estamina.")
	state.tick(CombatState.GUARD_BREAK_TIME + 0.05)
	_check(state.guard_break == 0.0 and state.can_block(), "Tras la rotura se recupera el bloqueo.")

func _potion_recharge() -> void:
	var state := CombatState.new()
	_check(not state.drink() and state.potions == CombatState.POTION_MAX, "Con vida completa no se desperdicia la carga.")
	state.receive_hit(8, 0.0, false)
	_check(state.drink() and state.potions == 0, "Beber gasta una carga.")
	state.tick(10.0)
	state.mark_defeated(0, 2)
	_check(state.charge == 0 and state.potions == 0, "Ni esperar ni vencer un enemigo recargan automáticamente.")
	for _i in range(CombatState.HITS_PER_CHARGE - 1):
		state.register_effective_attack()
	_check(state.charge == CombatState.HITS_PER_CHARGE - 1 and not state.drink(),
		"Los ataques efectivos acumulan progreso antes de completar la carga.")
	state.register_effective_attack()
	_check(state.potions == 1 and state.charge == 0, "Se recupera una carga al acertar suficientes ataques al enemigo vivo.")
	state.register_effective_attack()
	_check(state.potions == CombatState.POTION_MAX and state.charge == 0, "La recarga no acumula por encima del máximo.")

func _save_and_end_states() -> void:
	var state := CombatState.new()
	state.receive_hit(11, 0.0, false)
	state.drink()
	state.tick(CombatState.HURT_PROTECTION)
	state.receive_hit(10, 0.0, false)
	state.spend_attack(true)
	state.register_effective_attack()
	state.mark_defeated(0, 2)
	var snapshot := state.snapshot()
	var resumed := CombatState.new()
	var parsed: Variant = JSON.parse_string(JSON.stringify(snapshot))
	_check(resumed.restore(parsed, 2) and resumed.snapshot() == snapshot and resumed.invulnerable == 0.0,
		"Se conservan vida, estamina, cargas, progreso y enemigos vencidos al leer el JSON.")
	var invalid := snapshot.duplicate(true)
	invalid.defeated = [0, 0]
	_check(not resumed.restore(invalid, 2) and resumed.snapshot() == snapshot,
		"Un guardado inválido no altera el estado que ya estaba cargado.")
	resumed.mark_defeated(0, 2)
	_check(resumed.status == "active" and resumed.defeated == [0], "La baja repetida no cuenta otra vez.")
	var ui := resumed.hud_data(2, "guard")
	_check(ui.enemies_alive == 1 and ui.player_mode == "guard" and ui.hp == resumed.hp,
		"La HUD recibe los valores del combate actual.")
	resumed.mark_defeated(1, 2)
	_check(resumed.status == "won" and not resumed.spend_attack(false), "El último enemigo termina la prueba por victoria.")
	state.tick(CombatState.HURT_PROTECTION)
	state.receive_hit(CombatState.HEALTH_MAX, 0.0, false)
	var defeated_player := CombatState.new()
	_check(state.status == "lost" and state.hp == 0 and defeated_player.restore(state.snapshot(), 2) and not defeated_player.drink(),
		"La derrota se registra en el impacto letal y permanece al cargar.")
