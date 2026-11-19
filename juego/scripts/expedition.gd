extends Node

signal changed
const Rules = preload("res://scripts/expedition_rules.gd")
const Store = preload("res://scripts/expedition_store.gd")
const Maps = preload("res://scripts/expedition_maps.gd")
var store = Store.new()
var state: Dictionary = {}
var notice := ""
var blocked := false
var testing := false
var dirty := false
var elapsed := 0.0

func _ready() -> void:
	testing = OS.get_cmdline_user_args().has("--test-mode")
	if testing:
		state = Rules.fresh()
		set_process(false)
		return
	state = store.read()
	notice = store.last_error
	if state.is_empty():
		state = Rules.fresh()
		blocked = not notice.is_empty()
	get_tree().auto_accept_quit = false
	if not blocked: flush()

func _process(delta: float) -> void:
	elapsed += delta
	if elapsed >= 2.0:
		elapsed = 0.0
		if dirty: flush()

func flush() -> bool:
	if testing or blocked: return false
	if not store.write(state):
		notice = store.last_error
		changed.emit()
		return false
	dirty = false
	return true

func execute(action: String, value: String = "") -> void:
	if blocked:
		notice = "Guardado detenido para conservar la copia existente. Importa una copia válida desde Partida y copias."
		changed.emit()
		return
	var candidate: Dictionary = state.duplicate(true)
	var result: String = Rules.command(candidate, action, value)
	if not testing and not store.write(candidate):
		notice = "No se pudo guardar el cambio. " + store.last_error
	else:
		state = candidate
		dirty = false
		notice = result
	changed.emit()

func move(direction: Vector2i) -> void:
	var run: Dictionary = state.active_run
	if blocked or run.is_empty() or not run.battle.is_empty() or not run.pending_offer.is_empty(): return
	var p := Vector2i(run.x, run.y) + direction
	if Maps.walkable(run.node, p):
		run.x = p.x
		run.y = p.y
		dirty = true
		changed.emit()

func import_text(text: String) -> bool:
	var candidate: Dictionary = Store.parse_text(text)
	if candidate.is_empty():
		notice = "La copia no es válida para Expediciones. No se sustituyó la partida."
		changed.emit()
		return false
	if not store.write(candidate):
		notice = store.last_error
		changed.emit()
		return false
	state = candidate
	blocked = false
	dirty = false
	notice = "Copia de expediciones importada."
	changed.emit()
	return true

func _notification(what: int) -> void:
	if testing or state.is_empty(): return
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		flush()
		get_tree().quit()
	elif what in [NOTIFICATION_APPLICATION_PAUSED, NOTIFICATION_APPLICATION_FOCUS_OUT]: flush()
