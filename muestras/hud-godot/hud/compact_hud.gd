extends Control
## HUD autónoma. Recibe datos de presentación; nunca accede a la partida o al disco.

signal map_requested
signal menu_requested
signal potion_requested
signal bag_toggled(open: bool)

const UI_FONT = preload("res://hud/assets/fonts/AtkinsonHyperlegible-Regular.ttf")
const UI_BOLD = preload("res://hud/assets/fonts/AtkinsonHyperlegible-Bold.ttf")
const PIXEL_FONT = preload("res://hud/assets/fonts/PixelifySans-Variable.ttf")
const PANEL_TEXTURE = preload("res://hud/assets/panel.svg")
const CAELAN = preload("res://hud/assets/caelan.png")
const ICONS = {
	"potion": preload("res://hud/assets/potion.svg"),
	"bag": preload("res://hud/assets/bag.svg"),
	"map": preload("res://hud/assets/map.svg"),
	"menu": preload("res://hud/assets/menu.svg"),
	"warning": preload("res://hud/assets/warning.svg"),
	"door": preload("res://hud/assets/door.svg")
}
const INK := Color("eee1c5")
const GOLD := Color("d8b071")
const LOW := Color("ffa28e")
const AMBER := Color("e9b962")
const DEFAULT_STATE := {
	"hp": 14, "max_hp": 38, "mp": 12, "max_mp": 22, "potions": 2,
	"bag_used": 6, "bag_capacity": 12, "objective": "Investiga la resonancia",
	"progress": "1/3", "hostile": true, "retreat_available": true,
	"materials": [{"name": "Madera", "amount": 4}, {"name": "Mineral", "amount": 2}, {"name": "Cristal", "amount": 1}]
}

var state: Dictionary = DEFAULT_STATE.duplicate(true)
var _scale := 1.0
var _built := false

func _ready() -> void:
	_prepare_theme()
	_prepare_portrait()
	$Hero/Potion.pressed.connect(func(): potion_requested.emit())
	$Navigation/Map.pressed.connect(func(): map_requested.emit())
	$Navigation/Menu.pressed.connect(func(): menu_requested.emit())
	$Bag.pressed.connect(func(): set_bag_open(not $BagPopup.visible))
	resized.connect(_layout)
	_built = true
	set_state({})

func _prepare_theme() -> void:
	var ui_theme := Theme.new()
	ui_theme.default_font = UI_FONT
	ui_theme.default_font_size = 21
	ui_theme.set_color("font_color", "Label", INK)
	ui_theme.set_color("font_color", "Button", INK)
	ui_theme.set_color("font_hover_color", "Button", Color("fff1ce"))
	ui_theme.set_color("font_pressed_color", "Button", Color("fff1ce"))
	ui_theme.set_constant("h_separation", "Button", 9)
	for type_name in ["Panel", "PanelContainer"]:
		ui_theme.set_stylebox("panel", type_name, _panel_style())
	ui_theme.set_stylebox("normal", "Button", _panel_style())
	ui_theme.set_stylebox("hover", "Button", _panel_style(Color("fff2d2")))
	ui_theme.set_stylebox("pressed", "Button", _panel_style(Color("b0cbb7")))
	ui_theme.set_stylebox("disabled", "Button", _panel_style(Color("838476")))
	var focus := StyleBoxFlat.new()
	focus.bg_color = Color.TRANSPARENT
	focus.border_color = Color("86dbc3")
	focus.set_border_width_all(2)
	focus.set_expand_margin_all(3)
	ui_theme.set_stylebox("focus", "Button", focus)
	theme = ui_theme
	$Hero/Name.add_theme_font_override("font", PIXEL_FONT)
	$Hero/LowHealth.add_theme_font_override("font", PIXEL_FONT)
	$Hero/Level.add_theme_color_override("font_color", GOLD)
	$Hero/LowHealth.add_theme_color_override("font_color", LOW)
	var warning := StyleBoxFlat.new()
	warning.bg_color = Color("4a211d")
	$Hero/LowHealth.add_theme_stylebox_override("normal", warning)
	for node in [$Hero/HealthValue, $Hero/ManaValue]:
		node.add_theme_font_override("font", UI_BOLD)
		node.add_theme_color_override("font_shadow_color", Color("121b18"))
		node.add_theme_constant_override("shadow_offset_x", 1)
		node.add_theme_constant_override("shadow_offset_y", 1)
	$Status/Hostile.add_theme_color_override("font_color", AMBER)
	for pair in [[$Hero/Health, Color("a84434")], [$Hero/Mana, Color("368d83")]]:
		var background := StyleBoxFlat.new()
		background.bg_color = Color("181b16")
		background.border_color = Color("9c8259")
		background.set_border_width_all(2)
		var fill := StyleBoxFlat.new()
		fill.bg_color = pair[1]
		pair[0].add_theme_stylebox_override("background", background)
		pair[0].add_theme_stylebox_override("fill", fill)
		pair[0].step = 0.01
	$Hero/Potion.icon = ICONS.potion
	$Hero/Potion.add_theme_stylebox_override("normal", StyleBoxEmpty.new())
	$Hero/Potion.add_theme_stylebox_override("hover", _flat(Color("3a3929")))
	$Hero/Potion.add_theme_stylebox_override("pressed", _flat(Color("4a4937")))
	$Navigation/Map.icon = ICONS.map
	$Navigation/Menu.icon = ICONS.menu
	$Bag.icon = ICONS.bag
	$Status/HostileIcon.texture = ICONS.warning
	$Status/RetreatIcon.texture = ICONS.door

func _panel_style(tint: Color = Color.WHITE) -> StyleBoxTexture:
	var style := StyleBoxTexture.new()
	style.texture = PANEL_TEXTURE
	style.texture_margin_left = 16
	style.texture_margin_right = 16
	style.texture_margin_top = 16
	style.texture_margin_bottom = 16
	style.modulate_color = tint
	style.content_margin_left = 16
	style.content_margin_right = 16
	style.content_margin_top = 12
	style.content_margin_bottom = 12
	return style

func _flat(color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	return style

func _prepare_portrait() -> void:
	var frame := StyleBoxFlat.new()
	frame.bg_color = Color("bbaf86")
	frame.border_color = Color("b89e68")
	frame.set_border_width_all(3)
	frame.set_corner_radius_all(70)
	$Hero/Portrait.add_theme_stylebox_override("panel", frame)
	var atlas := AtlasTexture.new()
	atlas.atlas = CAELAN
	atlas.region = Rect2(512, 64, 512, 690)
	$Hero/Portrait/Image.texture = atlas
	$Hero/Portrait/Image.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

func set_state(data: Dictionary) -> void:
	for key in data:
		if DEFAULT_STATE.has(key):
			state[key] = data[key].duplicate(true) if data[key] is Array or data[key] is Dictionary else data[key]
	# La normalización protege la presentación sin introducir reglas de juego.
	state.max_hp = _nonnegative_number(state.max_hp)
	state.max_mp = _nonnegative_number(state.max_mp)
	state.hp = clampf(_nonnegative_number(state.hp), 0.0, state.max_hp)
	state.mp = clampf(_nonnegative_number(state.mp), 0.0, state.max_mp)
	state.potions = int(_nonnegative_number(state.potions))
	state.bag_capacity = int(_nonnegative_number(state.bag_capacity))
	state.bag_used = int(_nonnegative_number(state.bag_used))
	state.objective = str(state.objective)
	state.progress = str(state.progress)
	state.hostile = bool(state.hostile)
	state.retreat_available = bool(state.retreat_available)
	if not state.materials is Array:
		state.materials = []
	if not _built:
		return
	_update_view()

func _nonnegative_number(value: Variant) -> float:
	if not (value is int or value is float):
		return 0.0
	var number := float(value)
	return maxf(0.0, number) if is_finite(number) else 0.0

func _update_view() -> void:
	$Hero/Health.max_value = maxf(1.0, state.max_hp)
	$Hero/Mana.max_value = maxf(1.0, state.max_mp)
	$Hero/Health.value = state.hp
	$Hero/Mana.value = state.mp
	$Hero/HealthValue.text = "%s/%s" % [_number(state.hp), _number(state.max_hp)]
	$Hero/ManaValue.text = "%s/%s" % [_number(state.mp), _number(state.max_mp)]
	$Hero/Potion.text = "[Q] ×%d" % state.potions
	$Hero/LowHealth.visible = state.max_hp > 0.0 and state.hp / state.max_hp <= 0.37
	var health_background: StyleBoxFlat = $Hero/Health.get_theme_stylebox("background").duplicate()
	health_background.border_color = Color("d8684c") if $Hero/LowHealth.visible else Color("9c8259")
	$Hero/Health.add_theme_stylebox_override("background", health_background)
	$Objective/Text.text = state.objective
	$Objective/Text.tooltip_text = state.objective
	$Objective/Progress.text = state.progress
	$Objective/Progress.tooltip_text = state.progress
	$Status/Hostile.visible = state.hostile
	$Status/HostileIcon.visible = state.hostile
	$Status/Divider.visible = state.hostile
	$Status/Retreat.text = "Retirada disponible" if state.retreat_available else "Retirada bloqueada"
	$Status/Retreat.tooltip_text = $Status/Retreat.text
	$Status/Retreat.add_theme_color_override("font_color", INK if state.retreat_available else Color("e5a585"))
	$Bag.text = "Mochila %d/%d  |  En riesgo" % [state.bag_used, state.bag_capacity]
	var full: bool = state.bag_capacity > 0 and state.bag_used >= state.bag_capacity
	$Bag.add_theme_color_override("font_color", AMBER if full else INK)
	_rebuild_materials()
	_layout()

func _number(value: float) -> String:
	return str(int(value)) if is_equal_approx(value, roundf(value)) else str(snappedf(value, 0.1))

func _rebuild_materials() -> void:
	for child in $BagPopup/Materials.get_children():
		$BagPopup/Materials.remove_child(child)
		child.queue_free()
	var title := Label.new()
	title.text = "Materiales transportados"
	title.add_theme_color_override("font_color", GOLD)
	$BagPopup/Materials.add_child(title)
	var count := 0
	for item in state.materials:
		if not item is Dictionary:
			continue
		var row := Label.new()
		row.text = "%s  ×%d" % [str(item.get("name", "Material")), int(_nonnegative_number(item.get("amount", 0)))]
		row.clip_text = true
		row.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		$BagPopup/Materials.add_child(row)
		count += 1
		if count >= 6:
			break
	if count == 0:
		var empty := Label.new()
		empty.text = "Sin materiales"
		$BagPopup/Materials.add_child(empty)
	var warning := Label.new()
	warning.text = "Se pierden si caes."
	warning.add_theme_color_override("font_color", Color("e1a784"))
	$BagPopup/Materials.add_child(warning)

func _layout() -> void:
	if not _built:
		return
	_scale = clampf(minf(size.x / 1600.0, size.y / 900.0), 0.60, 1.25)
	var s := _scale
	var margin := 32.0 * s
	_apply_scale(s)
	_place($Hero, Rect2(margin, margin, 440*s, 190*s))
	_place($Hero/Portrait, Rect2(22*s, 22*s, 109*s, 140*s))
	_place($Hero/Portrait/Image, Rect2(5*s, 5*s, 99*s, 130*s))
	_place($Hero/Name, Rect2(149*s, 23*s, 170*s, 36*s))
	_place($Hero/Level, Rect2(330*s, 23*s, 88*s, 36*s))
	_place($Hero/HealthLabel, Rect2(149*s, 75*s, 51*s, 26*s))
	_place($Hero/ManaLabel, Rect2(149*s, 106*s, 51*s, 26*s))
	_place($Hero/Health, Rect2(207*s, 78*s, 211*s, 24*s))
	_place($Hero/Mana, Rect2(207*s, 109*s, 211*s, 24*s))
	_place($Hero/HealthValue, Rect2(210*s, 78*s, 201*s, 24*s))
	_place($Hero/ManaValue, Rect2(210*s, 109*s, 201*s, 24*s))
	_place($Hero/Potion, Rect2(149*s, 140*s, 119*s, 32*s))
	_place($Hero/LowHealth, Rect2(309*s, 142*s, 109*s, 28*s))
	_place($Objective, Rect2(size.x-margin-410*s, margin, 410*s, 67*s))
	var progress_font_size := maxi(14, roundi(22*s))
	var measured_progress: float = UI_FONT.get_string_size(state.progress, HORIZONTAL_ALIGNMENT_LEFT, -1, progress_font_size).x
	var progress_width := clampf(measured_progress + 8*s, 49*s, 130*s)
	var progress_left := 392*s - progress_width
	_place($Objective/Text, Rect2(18*s, 12*s, progress_left-30*s, 43*s))
	_place($Objective/Progress, Rect2(progress_left, 12*s, progress_width, 43*s))
	_place($Status, Rect2(size.x-margin-410*s, 109*s, 410*s, 58*s))
	_place($Status/HostileIcon, Rect2(18*s, 18*s, 22*s, 24*s))
	_place($Status/Hostile, Rect2(48*s, 10*s, 74*s, 39*s))
	_place($Status/Divider, Rect2(132*s, 17*s, 1*s, 25*s))
	var retreat_left := 150.0 if state.hostile else 20.0
	_place($Status/RetreatIcon, Rect2(retreat_left*s, 17*s, 24*s, 25*s))
	_place($Status/Retreat, Rect2((retreat_left+31)*s, 10*s, (392-retreat_left-31)*s, 39*s))
	var map_width := maxf(181*s, $Navigation/Map.get_combined_minimum_size().x)
	var menu_width := maxf(196*s, $Navigation/Menu.get_combined_minimum_size().x)
	_place($Navigation, Rect2(margin, size.y-margin-64*s, map_width+14*s+menu_width, 64*s))
	_place($Navigation/Map, Rect2(0, 0, map_width, 64*s))
	_place($Navigation/Menu, Rect2(map_width+14*s, 0, menu_width, 64*s))
	_place($Bag, Rect2(size.x-margin-410*s, size.y-margin-64*s, 410*s, 64*s))
	# Container mínimo se recalcula tras cambiar sus textos; respetar su altura natural.
	var popup_height := maxf(172*s, $BagPopup.get_combined_minimum_size().y)
	_place($BagPopup, Rect2(size.x-margin-410*s, size.y-margin-80*s-popup_height, 410*s, popup_height))

func _apply_scale(s: float) -> void:
	for node in [$Hero/Name]:
		node.add_theme_font_size_override("font_size", roundi(31*s))
	for node in [$Hero/Level, $Objective/Text, $Objective/Progress, $Navigation/Map, $Navigation/Menu, $Bag]:
		node.add_theme_font_size_override("font_size", maxi(14, roundi(22*s)))
	for node in [$Hero/HealthLabel, $Hero/ManaLabel, $Hero/LowHealth]:
		node.add_theme_font_size_override("font_size", maxi(11, roundi(17*s)))
	for node in [$Hero/HealthValue, $Hero/ManaValue]:
		node.add_theme_font_size_override("font_size", maxi(12, roundi(18*s)))
	for node in [$Hero/Potion, $Status/Hostile, $Status/Retreat]:
		node.add_theme_font_size_override("font_size", maxi(13, roundi(20*s)))
	for button in [$Hero/Potion, $Navigation/Map, $Navigation/Menu, $Bag]:
		button.add_theme_constant_override("icon_max_width", maxi(19, roundi(30*s)))
		button.add_theme_constant_override("h_separation", maxi(4, roundi(9*s)))
	# Los mínimos del Button también deben reducirse; mover solo su rectángulo
	# deja que icono/texto/márgenes fijos invadan al siguiente botón a 960 px.
	for button in [$Navigation/Map, $Navigation/Menu, $Bag]:
		for style_name in ["normal", "hover", "pressed", "disabled"]:
			var style: StyleBoxTexture = theme.get_stylebox(style_name, "Button").duplicate()
			style.content_margin_left = roundf(16*s)
			style.content_margin_right = roundf(16*s)
			style.content_margin_top = roundf(12*s)
			style.content_margin_bottom = roundf(12*s)
			button.add_theme_stylebox_override(style_name, style)
	for child in $BagPopup/Materials.get_children():
		child.add_theme_font_size_override("font_size", maxi(13, roundi(20*s)))

func _place(control: Control, rect: Rect2) -> void:
	control.position = rect.position.round()
	control.size = rect.size.round()

func set_bag_open(open: bool) -> void:
	if not _built:
		return
	var changed: bool = $BagPopup.visible != open
	$BagPopup.visible = open
	$Bag.set_pressed_no_signal(open)
	if open:
		_layout()
	if changed:
		bag_toggled.emit(open)

func _unhandled_key_input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or event.echo or event.ctrl_pressed or event.alt_pressed or event.meta_pressed:
		return
	var focus := get_viewport().gui_get_focus_owner()
	if focus is LineEdit or focus is TextEdit or focus is Range or focus is OptionButton or focus is SpinBox:
		return
	if event.physical_keycode == KEY_ESCAPE or event.keycode == KEY_ESCAPE:
		if $BagPopup.visible:
			set_bag_open(false)
		else:
			menu_requested.emit()
		get_viewport().set_input_as_handled()
	elif event.physical_keycode == KEY_M or event.keycode == KEY_M:
		map_requested.emit()
		get_viewport().set_input_as_handled()
	elif event.physical_keycode == KEY_Q or event.keycode == KEY_Q:
		potion_requested.emit()
		get_viewport().set_input_as_handled()

func _input(event: InputEvent) -> void:
	if not _built or not $BagPopup.visible:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if not $BagPopup.get_global_rect().has_point(event.position) and not $Bag.get_global_rect().has_point(event.position):
			set_bag_open(false)
