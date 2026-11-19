extends Control

const HUD_SCENE = preload("res://hud/compact_hud.tscn")
const UI_FONT = preload("res://hud/assets/fonts/AtkinsonHyperlegible-Regular.ttf")
var hud: Control
var hp_slider: HSlider
var hp_output: Label
var retreat_option: OptionButton
var status_message: Label
var presets: Array[Button] = []
var long_objective: CheckBox
var zone_option: CheckBox

class GridBackdrop extends Control:
	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		resized.connect(queue_redraw)
	func _draw() -> void:
		draw_rect(Rect2(Vector2.ZERO,size),Color("182720"))
		for x in range(0,int(size.x),32): draw_line(Vector2(x,0),Vector2(x,size.y),Color(0.4,0.55,0.43,0.06))
		for y in range(0,int(size.y),32): draw_line(Vector2(0,y),Vector2(size.x,y),Color(0.4,0.55,0.43,0.06))
		draw_rect(Rect2(Vector2(20,20),size-Vector2(40,40)),Color("34483a"),false,1)

func caption(text: String, font_size: int = 19) -> Label:
	var item := Label.new()
	item.text = text
	item.add_theme_font_size_override("font_size",font_size)
	return item

func _ready() -> void:
	var skin := Theme.new()
	skin.default_font = UI_FONT
	skin.default_font_size = 20
	theme = skin
	var board := GridBackdrop.new()
	board.name = "Board"
	board.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	board.offset_bottom = -200
	add_child(board)
	var center_text := caption("ESPACIO DEL ESCENARIO · HUD EN PRUEBA",17)
	center_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	center_text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	center_text.modulate = Color(0.62,0.73,0.63,0.35)
	center_text.mouse_filter = Control.MOUSE_FILTER_IGNORE
	center_text.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	board.add_child(center_text)
	hud = HUD_SCENE.instantiate()
	hud.name = "HUD"
	hud.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	board.add_child(hud)
	hud.map_requested.connect(func(): report("Mapa seleccionado. La escena reutilizable emite la señal map_requested."))
	hud.menu_requested.connect(func(): report("Menú seleccionado. Diario, personaje y ajustes se conectarían desde el juego."))
	hud.potion_requested.connect(func(): report("Poción seleccionada. Se emite una señal; esta prueba no consume ni cura."))
	hud.bag_toggled.connect(func(open: bool): report("Mochila abierta." if open else "Mochila cerrada."))
	build_inspector()
	preset("low")
	var args := OS.get_cmdline_user_args()
	for argument in args:
		if argument.begins_with("--capture="):
			capture(argument.trim_prefix("--capture="))

func build_inspector() -> void:
	var panel := PanelContainer.new()
	panel.name = "Inspector"
	panel.anchor_top = 1
	panel.anchor_bottom = 1
	panel.anchor_right = 1
	panel.offset_left = 24
	panel.offset_right = -24
	panel.offset_top = -188
	panel.offset_bottom = -16
	var style := StyleBoxFlat.new()
	style.bg_color = Color("122019")
	style.border_color = Color("455f49")
	style.set_border_width_all(1)
	style.content_margin_left = 18
	style.content_margin_right = 18
	style.content_margin_top = 12
	style.content_margin_bottom = 12
	panel.add_theme_stylebox_override("panel",style)
	add_child(panel)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation",8)
	panel.add_child(column)
	column.add_child(caption("HUD nativa de Godot · Laboratorio independiente",23))
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation",14)
	column.add_child(row)
	var group := ButtonGroup.new()
	for data in [["Estado normal","normal"],["Vida baja","low"],["Mochila llena","full"]]:
		var b := Button.new()
		b.text = data[0]
		b.name = data[1].capitalize()
		b.toggle_mode = true
		b.button_group = group
		b.custom_minimum_size = Vector2(150,40)
		b.pressed.connect(preset.bind(data[1]))
		row.add_child(b)
		presets.append(b)
	row.add_child(caption("  Vida"))
	hp_slider = HSlider.new()
	hp_slider.name = "HP"
	hp_slider.min_value = 0
	hp_slider.max_value = 38
	hp_slider.step = 1
	hp_slider.custom_minimum_size.x = 160
	hp_slider.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	hp_slider.value_changed.connect(func(value: float):
		hud.set_state({"hp":int(value)})
		hp_output.text = "%d/38" % int(value)
		for b in presets: b.set_pressed_no_signal(false)
	)
	row.add_child(hp_slider)
	hp_output = caption("14/38")
	hp_output.custom_minimum_size.x = 67
	row.add_child(hp_output)
	row.add_child(caption("  Retirada"))
	retreat_option = OptionButton.new()
	retreat_option.name = "Retreat"
	retreat_option.add_item("Disponible")
	retreat_option.add_item("Bloqueada")
	retreat_option.custom_minimum_size.x = 155
	retreat_option.item_selected.connect(func(index: int): hud.set_state({"retreat_available":index == 0}))
	row.add_child(retreat_option)
	zone_option = CheckBox.new()
	zone_option.name = "Hostile"
	zone_option.text = "Hostil"
	zone_option.button_pressed = true
	zone_option.toggled.connect(func(value: bool): hud.set_state({"hostile":value}))
	row.add_child(zone_option)
	var second := HBoxContainer.new()
	column.add_child(second)
	long_objective = CheckBox.new()
	long_objective.name = "LongObjective"
	long_objective.text = "Probar objetivo largo"
	long_objective.toggled.connect(func(value: bool): hud.set_state({"objective":"Investiga las resonancias de los antiguos fragmentos del faro entre las raíces" if value else "Investiga la resonancia"}))
	second.add_child(long_objective)
	status_message = caption("",17)
	status_message.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	status_message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	status_message.modulate = Color("b6c5b1")
	second.add_child(status_message)
	column.add_child(caption("M: mapa · Q: poción · Esc: cerrar mochila / menú. Valores simulados, sin partida ni guardado.",16))

func preset(key: String) -> void:
	var is_normal := key == "normal"
	hud.set_state({"hp":38 if is_normal else 14,"max_hp":38,"mp":22 if is_normal else 12,"max_mp":22,"potions":2,"bag_used":12 if key == "full" else 6,"bag_capacity":12,"hostile":true,"retreat_available":true})
	hp_slider.set_value_no_signal(hud.state.hp)
	hp_output.text = "%d/38" % hud.state.hp
	retreat_option.select(0)
	zone_option.set_pressed_no_signal(true)
	var index := {"normal":0,"low":1,"full":2}
	for i in presets.size(): presets[i].set_pressed_no_signal(i == index.get(key,1))
	report("Cambia los estados para revisar la HUD. Esta escena no carga la campaña.")

func report(message: String) -> void:
	if is_instance_valid(status_message): status_message.text = message

func capture(path: String) -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	var image := get_viewport().get_texture().get_image()
	var result := image.save_png(path)
	print("HUD_CAPTURE ",result," ",path)
	get_tree().quit(0 if result == OK else 1)
