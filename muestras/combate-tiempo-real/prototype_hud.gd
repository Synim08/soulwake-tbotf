extends Control
## Interfaz del prototipo. Solo presenta el estado recibido de la arena.

signal resume_requested
signal restart_requested
signal show_damage_changed(enabled: bool)
signal show_charge_numbers_changed(enabled: bool)

const BODY_FONT = preload("res://assets/fonts/AtkinsonHyperlegible-Regular.ttf")
const BOLD_FONT = preload("res://assets/fonts/AtkinsonHyperlegible-Bold.ttf")
const PIXEL_FONT = preload("res://assets/fonts/PixelifySans-Variable.ttf")
const PANEL_TEXTURE = preload("res://assets/panel.svg")
const POTION_ICON = preload("res://assets/potion.svg")
const INK := Color("f0e4cb")
const GOLD := Color("dfb97a")
const MUTED := Color("b0baae")
const TEAL := Color("83d8b0")
const DANGER := Color("ffa994")

var _state: Dictionary = {}
var _status := "active"
var _paused := false
var _confirm_restart := false
var _show_damage := true
var _show_charge_numbers := true
var _health: ProgressBar
var _health_amount: Label
var _stamina: ProgressBar
var _stamina_amount: Label
var _player_mode: Label
var _potions: Label
var _charge: ProgressBar
var _charge_note: Label
var _enemies: Label
var _message: Label
var _overlay: ColorRect
var _modal_title: Label
var _modal_note: Label
var _resume: Button
var _restart: Button
var _damage_option: CheckButton
var _charge_option: CheckButton

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	var skin := Theme.new()
	skin.default_font = BODY_FONT
	skin.default_font_size = 17
	skin.set_color("font_color", "Label", INK)
	skin.set_color("font_color", "Button", INK)
	skin.set_color("font_hover_color", "Button", Color("fff1cd"))
	skin.set_color("font_pressed_color", "Button", Color("fff1cd"))
	for type in ["Button", "CheckButton"]:
		skin.set_stylebox("normal", type, _frame_style())
		skin.set_stylebox("hover", type, _frame_style(Color("fff2d1")))
		skin.set_stylebox("pressed", type, _frame_style(Color("bce0c0")))
		var focus := StyleBoxFlat.new()
		focus.bg_color = Color.TRANSPARENT
		focus.border_color = TEAL
		focus.set_border_width_all(2)
		focus.set_expand_margin_all(2)
		skin.set_stylebox("focus", type, focus)
	theme = skin
	_build_board()
	_build_overlay()
	set_preferences(_show_damage, _show_charge_numbers)
	sync(_state)
	_refresh_overlay()

func _build_board() -> void:
	var band := ColorRect.new()
	band.name = "CombatBoard"
	band.color = Color("101e19")
	_put(band, self, Rect2(0, 624, 1152, 144))
	var edge := ColorRect.new()
	edge.color = Color("8e744c")
	_put(edge, band, Rect2(0, 0, 1152, 2))
	var fighter := _panel(band, "Fighter", Rect2(18, 8, 384, 92))
	_label(fighter, "Caelan · Guardián", Rect2(15, 8, 220, 21), 21, GOLD, PIXEL_FONT)
	_player_mode = _label(fighter, "", Rect2(210, 9, 159, 20), 15, MUTED)
	_player_mode.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_label(fighter, "VIDA", Rect2(15, 34, 85, 21), 15, INK, BOLD_FONT)
	_label(fighter, "ESTAMINA", Rect2(15, 60, 85, 21), 15, INK, BOLD_FONT)
	_health = _bar(fighter, "HealthBar", Rect2(105, 36, 264, 18), Color("b4523e"))
	_stamina = _bar(fighter, "StaminaBar", Rect2(105, 62, 264, 18), Color("4e9d72"))
	_health_amount = _meter_caption(fighter, "HealthValue", Rect2(107, 34, 256, 22))
	_stamina_amount = _meter_caption(fighter, "StaminaValue", Rect2(107, 60, 256, 22))

	var potion := _panel(band, "Potion", Rect2(411, 8, 288, 92))
	var icon := TextureRect.new()
	icon.texture = POTION_ICON
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_put(icon, potion, Rect2(11, 7, 26, 28))
	_label(potion, "Poción", Rect2(43, 9, 147, 22), 21, GOLD, PIXEL_FONT)
	_potions = _label(potion, "", Rect2(197, 8, 74, 23), 18, INK, BOLD_FONT)
	_potions.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_charge = _bar(potion, "PotionCharge", Rect2(15, 42, 258, 13), Color("9f679e"))
	_charge_note = _label(potion, "", Rect2(15, 60, 258, 21), 15, MUTED)
	_charge_note.name = "PotionChargeNote"

	var encounter := _panel(band, "Encounter", Rect2(708, 8, 426, 92))
	_label(encounter, "Claro de savia", Rect2(15, 8, 290, 24), 21, GOLD, PIXEL_FONT)
	_enemies = _label(encounter, "", Rect2(15, 32, 395, 20), 16, INK, BOLD_FONT)
	_enemies.name = "EnemiesAlive"
	_message = _label(encounter, "", Rect2(15, 52, 395, 35), 14, MUTED)
	_message.name = "CombatMessage"
	_message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_message.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	_message.max_lines_visible = 2
	_message.clip_text = true
	_message.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS

	_label(band, "TECLADO", Rect2(23, 103, 90, 19), 14, GOLD, BOLD_FONT)
	_label(band, "WASD  mover   ·   Ratón  apuntar   ·   Izq.  ataque   ·   Der. / F  pesado   ·   Espacio  bloquear   ·   Q  poción   ·   Esc  pausa",
		Rect2(105, 103, 1027, 19), 15, MUTED)
	_label(band, "MANDO", Rect2(23, 122, 90, 19), 14, GOLD, BOLD_FONT)
	_label(band, "Stick izq.  mover   ·   Stick der.  apuntar   ·   X  ataque   ·   Y  pesado   ·   LB  bloquear   ·   B  poción   ·   Start  pausa",
		Rect2(105, 122, 1027, 19), 15, MUTED)

func _build_overlay() -> void:
	_overlay = ColorRect.new()
	_overlay.name = "PracticeMenu"
	_overlay.color = Color(0.027, 0.062, 0.052, 0.79)
	_put(_overlay, self, Rect2(0, 0, 1152, 768))
	_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	var container := _panel(_overlay, "Modal", Rect2(316, 174, 520, 414))
	_modal_title = _label(container, "", Rect2(24, 21, 472, 42), 36, GOLD, PIXEL_FONT)
	_modal_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_modal_note = _label(container, "", Rect2(34, 68, 452, 58), 19, INK)
	_modal_note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_modal_note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_resume = _button(container, "Resume", "Volver al claro", Rect2(58, 143, 404, 48))
	_resume.pressed.connect(func(): resume_requested.emit())
	_damage_option = _check(container, "ShowDamage", "Números de daño", Rect2(58, 203, 404, 43))
	_damage_option.toggled.connect(_toggle_damage)
	_charge_option = _check(container, "ShowChargeNumbers", "Cifras de recarga de poción", Rect2(58, 252, 404, 43))
	_charge_option.toggled.connect(_toggle_charge_numbers)
	_restart = _button(container, "Restart", "Reiniciar prueba", Rect2(58, 318, 404, 48))
	_restart.pressed.connect(_on_restart)
	_overlay.hide()

func sync(state: Dictionary) -> void:
	_state = state
	var new_status := str(state.get("status", "active"))
	var changed_status := _status != new_status
	_status = new_status
	if _health == null:
		return
	var hp := int(state.get("hp", 0))
	var max_hp := int(state.get("max_hp", 1))
	var stamina := float(state.get("stamina", 0.0))
	var max_stamina := int(state.get("max_stamina", 1))
	_health.max_value = maxi(1, max_hp)
	_health.value = hp
	_health_amount.text = "%d/%d" % [hp, max_hp]
	_health_amount.modulate = DANGER if hp <= max_hp * 0.25 else INK
	_stamina.max_value = maxi(1, max_stamina)
	_stamina.value = stamina
	_stamina_amount.text = "%d/%d" % [floori(stamina), max_stamina]
	_stamina_amount.modulate = DANGER if stamina < 1.0 else INK
	var mode := str(state.get("player_mode", "Listo"))
	_player_mode.text = mode
	_player_mode.modulate = DANGER if mode == "Guardia rota" else MUTED
	var alive := int(state.get("enemies_alive", 0))
	var total := int(state.get("enemy_total", 0))
	_enemies.text = "Enemigos vivos  %d/%d" % [alive, total]
	_message.text = str(state.get("message", ""))
	_refresh_charge()
	if changed_status:
		_paused = false
		_confirm_restart = false
		_refresh_overlay()

func set_paused(paused: bool) -> void:
	if _paused == paused:
		return
	_paused = paused
	_confirm_restart = false
	_refresh_overlay()

func set_preferences(damage: bool, charge_numbers: bool) -> void:
	_show_damage = damage
	_show_charge_numbers = charge_numbers
	if _damage_option == null:
		return
	_damage_option.set_pressed_no_signal(damage)
	_charge_option.set_pressed_no_signal(charge_numbers)
	_refresh_charge()

func _toggle_damage(enabled: bool) -> void:
	_show_damage = enabled
	show_damage_changed.emit(enabled)

func _toggle_charge_numbers(enabled: bool) -> void:
	_show_charge_numbers = enabled
	_refresh_charge()
	show_charge_numbers_changed.emit(enabled)

func _refresh_charge() -> void:
	var count := int(_state.get("potions", 0))
	var maximum := int(_state.get("max_potions", 1))
	var required := maxi(1, int(_state.get("hits_per_charge", 1)))
	var progress := clampi(int(_state.get("charge", 0)), 0, required)
	var full := count >= maximum
	_potions.text = "%d/%d" % [count, maximum]
	_potions.modulate = INK if count > 0 else MUTED
	_charge.max_value = required
	_charge.value = required if full else progress
	_charge_note.text = "Cargas al máximo" if full else "Se recarga al acertar"
	if not full and _show_charge_numbers:
		var remaining := required - progress
		_charge_note.text = "Falta 1 golpe" if remaining == 1 else "Faltan %d golpes" % remaining

func _refresh_overlay() -> void:
	if _overlay == null:
		return
	var finished := _status in ["won", "lost"]
	var show_overlay := _paused or finished
	if not show_overlay:
		var focused := get_viewport().gui_get_focus_owner()
		if focused != null and _overlay.is_ancestor_of(focused):
			focused.release_focus()
		_overlay.hide()
		return
	var was_visible := _overlay.visible
	_overlay.show()
	_resume.visible = not finished
	_damage_option.visible = not finished
	_charge_option.visible = not finished
	_restart.position.y = 318 if not finished else 222
	_restart.text = "Volver a probar" if finished else "Reiniciar prueba"
	if _status == "won":
		_modal_title.text = "Claro despejado"
		_modal_note.text = "Venciste a los enemigos del claro."
	elif _status == "lost":
		_modal_title.text = "Caelan ha caído"
		_modal_note.text = "Puedes volver a probar el encuentro desde el inicio."
	else:
		_modal_title.text = "Pausa"
		_modal_note.text = "Ajusta las señales de combate o vuelve al claro."
		if _confirm_restart:
			_modal_note.text = "Perderás el progreso de esta prueba. Pulsa de nuevo para reiniciar."
			_restart.text = "Confirmar reinicio"
	if finished:
		_restart.grab_focus()
	else:
		var focused := get_viewport().gui_get_focus_owner()
		if not was_visible or focused == null or not _overlay.is_ancestor_of(focused):
			_resume.grab_focus()

func _on_restart() -> void:
	if _status in ["won", "lost"] or _confirm_restart:
		_confirm_restart = false
		restart_requested.emit()
		return
	_confirm_restart = true
	_refresh_overlay()

func _put(item: Control, parent: Node, rect: Rect2) -> void:
	item.position = rect.position
	item.size = rect.size
	item.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(item)

func _frame_style(tint: Color = Color.WHITE) -> StyleBoxTexture:
	var style := StyleBoxTexture.new()
	style.texture = PANEL_TEXTURE
	style.modulate_color = tint
	for side in [SIDE_LEFT, SIDE_TOP, SIDE_RIGHT, SIDE_BOTTOM]:
		style.set_texture_margin(side, 16)
		style.set_content_margin(side, 12)
	return style

func _panel(parent: Node, node_name: String, rect: Rect2) -> Panel:
	var item := Panel.new()
	item.name = node_name
	item.add_theme_stylebox_override("panel", _frame_style())
	_put(item, parent, rect)
	return item

func _label(parent: Node, value: String, rect: Rect2, font_size: int,
		color: Color, font: Font = BODY_FONT) -> Label:
	var item := Label.new()
	item.add_theme_font_override("font", font)
	item.add_theme_font_size_override("font_size", font_size)
	item.add_theme_color_override("font_color", color)
	item.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	item.clip_text = true
	item.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	item.text = value
	_put(item, parent, rect)
	return item

func _meter_caption(parent: Node, node_name: String, rect: Rect2) -> Label:
	var item := _label(parent, "", rect, 15, Color.WHITE, BOLD_FONT)
	item.name = node_name
	item.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	item.add_theme_color_override("font_outline_color", Color("101613"))
	item.add_theme_constant_override("outline_size", 2)
	return item

func _bar(parent: Node, node_name: String, rect: Rect2, color: Color) -> ProgressBar:
	var background := StyleBoxFlat.new()
	background.bg_color = Color("131913")
	background.border_color = Color("a08760")
	background.set_border_width_all(1)
	var fill := StyleBoxFlat.new()
	fill.bg_color = color
	var item := ProgressBar.new()
	item.name = node_name
	item.step = 0
	item.show_percentage = false
	item.add_theme_stylebox_override("background", background)
	item.add_theme_stylebox_override("fill", fill)
	_put(item, parent, rect)
	return item

func _button(parent: Node, node_name: String, value: String, rect: Rect2) -> Button:
	var item := Button.new()
	item.name = node_name
	item.text = value
	_put(item, parent, rect)
	item.mouse_filter = Control.MOUSE_FILTER_STOP
	return item

func _check(parent: Node, node_name: String, value: String, rect: Rect2) -> CheckButton:
	var item := CheckButton.new()
	item.name = node_name
	item.text = value
	_put(item, parent, rect)
	item.mouse_filter = Control.MOUSE_FILTER_STOP
	return item
