extends Node

signal changed
signal message(text: String)

const Economy = preload("res://scripts/economy.gd")
const Combat = preload("res://scripts/combat.gd")
const SaveStore = preload("res://scripts/save_store.gd")
var store := SaveStore.new()
var state: Dictionary = {}
var save_blocked := false
var welcome := ""
var elapsed := 0.0
var autosave := 0.0
var enemies := {
	"slime": preload("res://data/slime.tres"),
	"wolf": preload("res://data/wolf.tres"),
	"bat": preload("res://data/bat.tres"),
	"guardian": preload("res://data/guardian.tres")}

static func fresh() -> Dictionary:
	return {"schema": 1, "region": "village", "x": 11, "y": 12,
		"hp": 38, "mp": 12, "potions": 3, "last_time": Time.get_unix_time_from_system(),
		"resources": {"gold": 20, "wood": 6, "ore": 0, "ingot": 0},
		"flags": {"mine_open": false, "forge_repaired": false, "sword": false, "boss_defeated": false, "beacon": false},
		"workers": {"mara": false, "ivo": false},
		"production": {"mine": 0, "forge": 0, "remainder": 0.0},
		"defeated": [], "battle": {}}

func _ready() -> void:
	if OS.get_cmdline_user_args().has("--test-mode"):
		state = fresh()
		save_blocked = true
		set_process(false)
		return
	state = store.read()
	var load_message := store.last_error
	if state.is_empty():
		state = fresh()
		save_blocked = not load_message.is_empty()
	else:
		var gains := settle()
		if gains.seconds >= 10 and (state.workers.mara or state.workers.ivo):
			welcome = "Mientras no estabas · %.0f s\nMineral: %+d · Lingotes: %+d\nLa fundición consume mineral. Máximo offline: 8 horas." % [gains.seconds, gains.ore, gains.ingot]
	if not load_message.is_empty():
		welcome = load_message + ("\n\n" + welcome if not welcome.is_empty() else "")
	# Commit offline settlement immediately; reloading cannot pay it twice.
	if not save_blocked:
		persist()
	get_tree().auto_accept_quit = false

func _process(delta: float) -> void:
	elapsed += delta
	autosave += delta
	if elapsed >= 0.5:
		elapsed = 0.0
		settle()
		changed.emit()
	if autosave >= 5.0:
		autosave = 0.0
		persist()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		settle()
		persist()
		get_tree().quit()
	elif what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		if not state.is_empty():
			settle()
			persist()

func settle() -> Dictionary:
	var now := Time.get_unix_time_from_system()
	var result := Economy.advance(state, maxf(0.0, now - float(state.last_time)))
	state.last_time = now
	return result

func persist() -> bool:
	if save_blocked:
		return false
	var ok := store.write(state)
	if not ok:
		message.emit(store.last_error)
	return ok

func commit(text: String = "") -> void:
	persist()
	changed.emit()
	if not text.is_empty():
		message.emit(text)

func objective() -> String:
	if not state.flags.mine_open:
		return "Recupera la mina\nCruza el bosque y derrota al lobo del sendero."
	if not state.flags.forge_repaired:
		return "Enciende la herrería\nVuelve al pueblo. Repararla cuesta 6 de madera y 10 monedas."
	if not state.flags.sword:
		return "Prepara tu espada\nAsigna a Mara e Ivo. Fabrica una espada con 3 lingotes."
	if not state.flags.boss_defeated:
		return "La veta antigua\nEntra en la mina y derrota a su guardián."
	if not state.flags.beacon:
		return "Una luz para el valle\nRegresa al faro del pueblo y restáuralo con 2 lingotes."
	return "El valle vuelve a respirar\nPrimera aventura completada. Tu pueblo sigue trabajando."

func interact(id: String) -> void:
	settle()
	match id:
		"elder":
			message.emit("Alba, guardiana del valle\nLa mina está tras el bosque, al este. Recupera el sendero y podremos reconstruir la herrería.\n\n" + objective())
		"rest":
			state.hp = 38
			state.mp = 12
			commit("Descansas junto al fuego. Vida y maná restaurados sin coste.")
		"forge":
			if not state.flags.mine_open:
				message.emit("La herrería está abandonada. Recupera primero el sendero de la mina.")
			elif not state.flags.forge_repaired:
				if state.resources.wood < 6 or state.resources.gold < 10:
					message.emit("Necesitas 6 de madera y 10 monedas para reparar la herrería.")
				else:
					state.resources.wood -= 6
					state.resources.gold -= 10
					state.flags.forge_repaired = true
					commit("¡Herrería reparada! Ivo ya puede fundir mineral. Habla con él para asignarlo.")
			elif state.flags.sword:
				message.emit("Tu espada del valle ya está equipada: ataque 12. Ivo puede seguir preparando lingotes para el faro.")
			elif state.resources.ingot < 3:
				message.emit("Espada del valle · 3 lingotes\nAsigna a Mara a la mina y a Ivo a la fundición. También puedes recoger mineral a mano en la mina.")
			else:
				state.resources.ingot -= 3
				state.flags.sword = true
				commit("Espada del valle fabricada y equipada. Ataque: 7 → 12. El guardián te espera en la mina.")
		"mara":
			if not state.flags.mine_open:
				message.emit("Mara, minera\nDespeja el sendero del bosque para que pueda volver a trabajar.")
			else:
				state.workers.mara = not state.workers.mara
				commit("Mara: " + ("trabajando · 1 mineral cada 5 s." if state.workers.mara else "descansando. Vuelve a hablar para asignarla."))
		"ivo":
			if not state.flags.forge_repaired:
				message.emit("Ivo, herrero\nRepara la herrería y convertiré el mineral de Mara en lingotes.")
			else:
				state.workers.ivo = not state.workers.ivo
				commit("Ivo: " + ("trabajando · 2 minerales → 1 lingote cada 8 s, si hay material." if state.workers.ivo else "descansando. Vuelve a hablar para asignarlo."))
		"ore":
			state.resources.ore = mini(9999, state.resources.ore + 1)
			commit("Recoges 1 mineral de la veta. Mara puede automatizar esta tarea.")
		"beacon":
			if state.flags.beacon:
				message.emit("El faro vuelve a iluminar el valle. Has completado la primera aventura.")
			elif not state.flags.boss_defeated:
				message.emit("El faro permanece apagado. El guardián de la mina custodia el cristal que necesita.")
			elif state.resources.ingot < 2:
				message.emit("Ya tienes el cristal del guardián. Necesitas 2 lingotes para restaurar el faro.")
			else:
				state.resources.ingot -= 2
				state.flags.beacon = true
				commit("¡El valle vuelve a respirar!\nHas recuperado la mina, reconstruido la herrería y encendido el faro. Esta es la primera aventura de un mundo por crecer.")
		"supplies":
			if state.resources.gold < 6:
				message.emit("Una poción cuesta 6 monedas. Descansar en el fuego es gratis.")
			else:
				state.resources.gold -= 6
				state.potions += 1
				commit("Compras una poción: restaura hasta 22 PV durante el combate.")
		"sell_ore":
			if state.resources.ore <= 0:
				message.emit("No tienes mineral. Recógelo en la mina o asigna a Mara para producirlo.")
			else:
				state.resources.ore -= 1
				state.resources.gold += 3
				commit("Vendes 1 mineral por 3 monedas.")

func start_battle(type: String, instance: String) -> void:
	if not state.battle.is_empty() or state.defeated.has(instance):
		return
	if type == "guardian" and not state.flags.sword:
		message.emit("La armadura del guardián exige preparación. Fabrica tu espada en la herrería antes de desafiarlo.")
		return
	state.battle = Combat.create(enemies[type], instance)
	commit()

func battle_action(action: String) -> String:
	if state.battle.is_empty():
		return ""
	var result := Combat.act(state, action, enemies[state.battle.enemy])
	commit()
	return result

func finish_battle() -> void:
	if state.battle.is_empty() or state.battle.status == "fighting":
		return
	if state.battle.status == "lost":
		state.hp = 38
		state.mp = 12
		state.region = "village"
		state.x = 11
		state.y = 12
	state.battle = {}
	commit()

func change_region(region: String, point: Vector2i) -> void:
	state.region = region
	state.x = point.x
	state.y = point.y
	commit()

func import_text(text: String) -> bool:
	var parsed: Variant = SaveStore.parse_text(text)
	if not SaveStore.valid(parsed):
		message.emit("La copia no es una partida válida de esta versión. Tu partida actual sigue intacta.")
		return false
	var incoming: Dictionary = SaveStore.normalize(parsed)
	var now := Time.get_unix_time_from_system()
	Economy.advance(incoming, maxf(0.0, now - float(incoming.last_time)))
	incoming.last_time = now
	# Commit to storage first. A failed write must not replace the live session.
	if not store.write(incoming):
		message.emit("No se pudo guardar la copia importada. Tu partida actual sigue intacta. " + store.last_error)
		return false
	state = incoming
	save_blocked = false
	changed.emit()
	message.emit("Copia importada y guardada.")
	return true

func debug_advance(seconds: float) -> void:
	Economy.advance(state, seconds)
	commit("Tiempo de prueba avanzado: %.0f s." % seconds)
