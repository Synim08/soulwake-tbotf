extends Control

const Regions = preload("res://scripts/regions.gd")
const World = preload("res://scripts/world.gd")
const Combat = preload("res://scripts/combat.gd")
const Builds = preload("res://scripts/build_rules.gd")
const CharacterPanel = preload("res://scripts/character_panel.gd")
const INK := Color("e4eadf")
const MUTED := Color("9cacaa")
const GOLD := Color("e6c485")
const GREEN := Color("8ac3a5")
var world
var resources_label: Label
var objective_label: Label
var worker_label: Label
var region_label: Label
var nearby_label: Label
var save_label: Label
var life_label: Label
var overlay: ColorRect
var modal_content: VBoxContainer
var modal_kind := ""
var battle_text: Label
var battle_intent: Label
var battle_hp: ProgressBar
var enemy_hp: Label
var battle_player: Label
var battle_buttons: HBoxContainer
var finish_button: Button
var io_text: TextEdit
var io_status: Label
var clipboard_callback: JavaScriptObject
var clipboard_error_callback: JavaScriptObject
var clock := 0.0
var character_panel

func _ready() -> void:
	character_panel = CharacterPanel.new(self)
	_configure_input()
	_theme()
	_build_ui()
	Game.changed.connect(_refresh)
	Game.message.connect(_show_message)
	_refresh()
	if not Game.state.battle.is_empty():
		_show_battle()
	elif not Game.welcome.is_empty():
		_show_message(Game.welcome)

func _configure_input() -> void:
	var bindings := {"move_up": [KEY_W, KEY_UP], "move_down": [KEY_S, KEY_DOWN],
		"move_left": [KEY_A, KEY_LEFT], "move_right": [KEY_D, KEY_RIGHT],
		"interact": [KEY_E, KEY_SPACE]}
	for action in bindings:
		if not InputMap.has_action(action):
			InputMap.add_action(action)
		for key in bindings[action]:
			var event := InputEventKey.new()
			event.physical_keycode = key
			InputMap.action_add_event(action, event)

func _theme() -> void:
	var t := Theme.new()
	t.default_font_size = 16
	t.set_color("font_color", "Label", INK)
	t.set_color("font_color", "Button", INK)
	t.set_color("font_hover_color", "Button", GOLD)
	t.set_color("font_disabled_color", "Button", Color("64716f"))
	t.set_stylebox("normal", "Button", _style(Color("263a3d"), Color("405453"), 8, 12))
	t.set_stylebox("hover", "Button", _style(Color("324b4b"), GREEN, 8, 12))
	t.set_stylebox("pressed", "Button", _style(Color("172e31"), GOLD, 8, 12))
	t.set_stylebox("focus", "Button", _style(Color(0,0,0,0), GOLD, 8, 3))
	t.set_stylebox("disabled", "Button", _style(Color("1b2b2f"), Color("293d40"), 8, 12))
	t.set_stylebox("background", "ProgressBar", _style(Color("14282c"), Color("31484a"), 4, 2))
	t.set_stylebox("fill", "ProgressBar", _style(GREEN, GREEN, 4, 2))
	t.set_stylebox("normal", "TextEdit", _style(Color("12252a"), Color("4f6967"), 6, 12))
	t.set_color("font_color", "TextEdit", INK)
	theme = t

func _style(bg: Color, border: Color, radius: int = 10, margin: int = 16) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = border
	s.set_border_width_all(1)
	s.set_corner_radius_all(radius)
	s.content_margin_left = margin
	s.content_margin_right = margin
	s.content_margin_top = margin
	s.content_margin_bottom = margin
	return s

func _label(text: String, size: int = 16, color: Color = INK) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", color)
	return label

func _wrapped(text: String, size: int = 16, color: Color = INK) -> Label:
	var label := _label(text, size, color)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return label

func _button(text: String, callback: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size.y = 42
	button.pressed.connect(callback)
	return button

func _card() -> PanelContainer:
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", _style(Color("1b3035"), Color("354d4e")))
	return panel

func _build_ui() -> void:
	var backdrop := ColorRect.new()
	backdrop.color = Color("101e24")
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(backdrop)
	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for edge in ["left", "right", "top", "bottom"]:
		margin.add_theme_constant_override("margin_" + edge, 20)
	add_child(margin)
	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 12)
	margin.add_child(root)
	var header := HBoxContainer.new()
	root.add_child(header)
	var brand := VBoxContainer.new()
	brand.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(brand)
	brand.add_child(_label("AVENTURA DEL VALLE", 27, GOLD))
	brand.add_child(_label("Recupera un lugar. Dale un futuro.", 15, MUTED))
	var controls := VBoxContainer.new()
	header.add_child(controls)
	save_label = _label("Guardado automático · cada 5 s", 12, MUTED)
	controls.add_child(save_label)
	controls.add_child(_button("Partida y copias", _show_save_menu))
	var resource_card := _card()
	root.add_child(resource_card)
	var resource_row := HBoxContainer.new()
	resource_card.add_child(resource_row)
	resources_label = _label("", 17, GOLD)
	resources_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	resource_row.add_child(resources_label)
	life_label = _label("", 16, GREEN)
	resource_row.add_child(life_label)
	var body := HBoxContainer.new()
	body.add_theme_constant_override("separation", 16)
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(body)
	var map_column := VBoxContainer.new()
	map_column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.add_child(map_column)
	region_label = _label("", 19)
	map_column.add_child(region_label)
	var map_panel := _card()
	map_panel.add_theme_stylebox_override("panel", _style(Color("17282d"), Color("526a60"), 10, 4))
	map_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	map_column.add_child(map_panel)
	var container := SubViewportContainer.new()
	container.stretch = true
	container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	map_panel.add_child(container)
	var viewport := SubViewport.new()
	viewport.size = Vector2i(768, 544)
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	container.add_child(viewport)
	world = World.new()
	viewport.add_child(world)
	world.interaction_requested.connect(_interact)
	world.nearby_changed.connect(func(text: String): nearby_label.text = text if is_instance_valid(nearby_label) else "")
	nearby_label = _wrapped("Acércate y pulsa E para interactuar.", 14, GOLD)
	map_column.add_child(nearby_label)
	var sidebar_scroll := ScrollContainer.new()
	sidebar_scroll.custom_minimum_size.x = 282
	sidebar_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	body.add_child(sidebar_scroll)
	var sidebar := VBoxContainer.new()
	sidebar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sidebar.add_theme_constant_override("separation", 8)
	sidebar_scroll.add_child(sidebar)
	var quest_card := _card()
	sidebar.add_child(quest_card)
	var quest_box := VBoxContainer.new()
	quest_box.add_theme_constant_override("separation", 10)
	quest_card.add_child(quest_box)
	quest_box.add_child(_label("TU SIGUIENTE PASO", 12, GOLD))
	objective_label = _wrapped("", 17)
	quest_box.add_child(objective_label)
	var worker_card := _card()
	sidebar.add_child(worker_card)
	var worker_box := VBoxContainer.new()
	worker_box.add_theme_constant_override("separation", 10)
	worker_card.add_child(worker_box)
	worker_box.add_child(_label("EL PUEBLO TRABAJA", 12, GREEN))
	worker_label = _wrapped("", 15, MUTED)
	worker_box.add_child(worker_label)
	worker_box.add_child(_wrapped("Habla con Mara e Ivo para asignarlos. Siguen trabajando al cerrar el juego, hasta 8 horas.", 13, MUTED))
	sidebar.add_child(_button("Personaje y estilos", func(): character_panel.show_panel()))
	sidebar.add_child(_button("Diario del valle", _show_journal))
	sidebar.add_child(_button("Volver al pueblo", _return_home))
	sidebar.add_child(_button("Cómo jugar", _show_help))
	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	sidebar.add_child(spacer)
	var footer := HBoxContainer.new()
	footer.add_theme_constant_override("separation", 6)
	root.add_child(footer)
	footer.add_child(_label("WASD / flechas", 13, MUTED))
	for pair in [["<", Vector2i.LEFT], ["^", Vector2i.UP], ["v", Vector2i.DOWN], [">", Vector2i.RIGHT]]:
		var direction: Vector2i = pair[1]
		footer.add_child(_button(pair[0], func(): world.move(direction)))
	var interaction := _button("E · Interactuar", func(): world.interact_nearby())
	interaction.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	footer.add_child(interaction)
	_build_overlay()
	world.refresh()

func _build_overlay() -> void:
	overlay = ColorRect.new()
	overlay.color = Color(0.02, 0.05, 0.07, 0.88)
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(overlay)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.add_child(center)
	var panel := _card()
	panel.custom_minimum_size = Vector2(650, 0)
	center.add_child(panel)
	modal_content = VBoxContainer.new()
	modal_content.add_theme_constant_override("separation", 16)
	panel.add_child(modal_content)
	overlay.hide()

func _modal(kind: String, title: String) -> void:
	for child in modal_content.get_children():
		modal_content.remove_child(child)
		child.queue_free()
	modal_kind = kind
	modal_content.add_child(_label(title, 26, GOLD))
	overlay.show()
	world.enabled = false

func _close_modal() -> void:
	overlay.hide()
	modal_kind = ""
	world.enabled = true
	if not Game.state.battle.is_empty():
		_show_battle()

func _show_message(text: String) -> void:
	_modal("message", "Historias del valle")
	modal_content.add_child(_wrapped(text, 18))
	var close := _button("Continuar", _close_modal)
	modal_content.add_child(close)
	close.grab_focus()

func _interact(obj: Dictionary) -> void:
	if obj.kind == "portal":
		if obj.to == "mine" and not Game.state.flags.mine_open:
			_show_message("El lobo aún domina el sendero. Acércate a él y pulsa E para combatir.")
		else:
			Game.change_region(obj.to, obj.spawn)
			world.rebuild()
	elif obj.kind == "enemy":
		Game.start_battle(obj.enemy, obj.id)
		if not Game.state.battle.is_empty():
			_show_battle()
	elif obj.id == "supplies":
		_show_shop()
	else:
		Game.interact(obj.id)

func _show_shop() -> void:
	_modal("shop", "Suministros del refugio")
	modal_content.add_child(_wrapped("Poción · 6 monedas · recupera hasta 22 PV en combate.\n\nTambién puedes vender mineral: 1 mineral por 3 monedas. Descansar en el fuego siempre es gratis.",18))
	modal_content.add_child(_button("Comprar poción · 6 monedas", func(): Game.interact("supplies")))
	modal_content.add_child(_button("Vender 1 mineral · +3 monedas", func(): Game.interact("sell_ore")))
	modal_content.add_child(_button("Volver", _close_modal))

func _show_battle() -> void:
	_modal("battle", ("Entrenamiento · " if Game.state.battle.practice else "") + Game.enemies[Game.state.battle.enemy].display_name)
	modal_content.add_child(_label("COMBATE POR TURNOS · puedes pensar sin límite de tiempo", 12, MUTED))
	battle_hp = ProgressBar.new()
	battle_hp.custom_minimum_size.y = 18
	battle_hp.show_percentage = false
	modal_content.add_child(battle_hp)
	enemy_hp = _label("", 14, MUTED)
	modal_content.add_child(enemy_hp)
	battle_intent = _wrapped("", 19, GOLD)
	modal_content.add_child(battle_intent)
	battle_text = _wrapped("", 17)
	battle_text.custom_minimum_size.y = 60
	modal_content.add_child(battle_text)
	battle_player = _wrapped("", 16, GREEN)
	modal_content.add_child(battle_player)
	battle_buttons = HBoxContainer.new()
	battle_buttons.add_theme_constant_override("separation", 8)
	modal_content.add_child(battle_buttons)
	for pair in [["Atacar", "attack"], ["Chispa · 4 PM", "magic"], ["Defender", "defend"], ["Poción", "potion"], ["Retirarse", "flee"]]:
		var action: String = pair[1]
		battle_buttons.add_child(_button(pair[0], func():
			var result := Game.battle_action(action)
			_refresh_battle()
			battle_text.text = result))
	finish_button = _button("Continuar", func():
		Game.finish_battle()
		_close_modal()
		world.rebuild())
	modal_content.add_child(finish_button)
	_refresh_battle()
	if Game.state.battle.status == "fighting":
		battle_buttons.get_child(0).grab_focus()
	else:
		finish_button.grab_focus()

func _refresh_battle() -> void:
	if Game.state.battle.is_empty() or modal_kind != "battle":
		return
	var b: Dictionary = Game.state.battle
	var enemy: Resource = Game.enemies[b.enemy]
	var stats := Builds.stats(Game.state)
	battle_hp.max_value = enemy.max_hp
	battle_hp.value = b.hp
	enemy_hp.text = "Enemigo · %d / %d PV" % [b.hp, enemy.max_hp]
	battle_text.text = b.message
	battle_player.text = "%s · %d/38 PV    %d/12 PM    %d pociones    Ataque %d" % [Builds.STYLES[Game.state.active_style].name, Game.state.hp, Game.state.mp, Game.state.potions, stats.attack]
	battle_buttons.get_child(1).text = "Chispa · %d PM" % stats.magic_cost
	var active: bool = b.status == "fighting"
	battle_buttons.visible = active
	finish_button.visible = not active
	battle_intent.text = "Intención: " + Combat.intention(b, enemy) if active else {"won": "Victoria · recompensa guardada", "lost": "Derrota · volverás al pueblo con vida", "escaped": "Retirada segura"}.get(b.status, "")
	if b.practice and not active:
		battle_intent.text = "Entrenamiento terminado · tus suministros se restauran al continuar"
	if active and b.burn_turns > 0:
		battle_intent.text += "\nQuemadura: %d acciones restantes · 2 de daño por acción" % b.burn_turns
	if active and Game.state.active_style == "ranger":
		battle_intent.text += "\nPróximo crítico en %d ataque(s)" % (stats.critical_interval - int(b.focus))
	if not active:
		finish_button.grab_focus()

func _refresh() -> void:
	if not is_instance_valid(resources_label):
		return
	var s: Dictionary = Game.state
	resources_label.text = "Monedas  %d     Madera  %d     Mineral  %d     Lingotes  %d" % [s.resources.gold, s.resources.wood, s.resources.ore, s.resources.ingot]
	life_label.text = "PV %d/38   PM %d/12" % [s.hp, s.mp]
	objective_label.text = Game.objective()
	worker_label.text = "Mara · " + ("1 mineral / 5 s" if s.workers.mara else "sin asignar") + "\nIvo · " + ("fundiendo: 2 minerales / lingote" if s.workers.ivo else "sin asignar")
	region_label.text = Regions.NAMES[s.region]
	save_label.text = "Guardado detenido · importa una copia" if Game.save_blocked else "v0.2 · Guardado automático · cada 5 s"
	world.refresh()
	if modal_kind == "battle":
		_refresh_battle()

func _show_journal() -> void:
	var s: Dictionary = Game.state
	var text := ""
	for pair in [["Recuperar la mina", s.flags.mine_open], ["Reparar la herrería", s.flags.forge_repaired], ["Fabricar la espada del valle", s.flags.sword], ["Derrotar al guardián", s.flags.boss_defeated], ["Restaurar el faro", s.flags.beacon]]:
		text += ("[Hecho]  " if pair[1] else "[ ]  ") + pair[0] + "\n\n"
	_show_message(text + "Objetivo actual\n" + Game.objective())

func _return_home() -> void:
	if not Game.state.battle.is_empty():
		_show_battle()
		return
	Game.change_region("village", Vector2i(11,12))
	world.rebuild()

func _show_help() -> void:
	_show_message("Muévete con WASD, flechas o los botones inferiores. Acércate a algo y pulsa E o Interactuar.\n\nEn combate, Defender recupera maná y reduce el daño. Observa el golpe pesado de cada tercer turno. Puedes retirarte sin penalización.\n\nEn el pueblo, abre Personaje y estilos para elegir talento, equiparte y entrenar sin gastar tus suministros. Cada estilo recuerda su equipo.\n\nDescansar en el fuego es gratis. Esta versión usa gráficos provisionales, no tiene sonido ni renacimiento.")

func _show_save_menu() -> void:
	if not Game.state.battle.is_empty():
		_show_battle()
		return
	_modal("save", "Tu partida")
	modal_content.add_child(_wrapped("Se guarda automáticamente cada 5 s y tras las acciones importantes. Guarda una copia exportada antes de cambiar de navegador o borrar sus datos.",16,MUTED))
	modal_content.add_child(_button("Guardar ahora", func():
		Game.settle()
		if Game.persist():
			_show_message("Partida guardada.")
		else:
			_show_message("No se pudo guardar. Exporta una copia para conservar tu progreso.")))
	modal_content.add_child(_button("Exportar copia", _export_copy))
	modal_content.add_child(_button("Importar copia", _import_copy))
	if OS.has_feature("editor"):
		modal_content.add_child(_button("Desarrollo · avanzar 60 s", func(): Game.debug_advance(60)))
	modal_content.add_child(_button("Volver", _close_modal))

func _export_copy() -> void:
	Game.settle()
	Game.persist()
	_modal("export", "Copia de tu aventura")
	modal_content.add_child(_wrapped("Selecciona y copia todo el texto. Guárdalo en un archivo .json. La copia incluye recursos, tareas, misiones y progreso.",16,MUTED))
	io_text = TextEdit.new()
	io_text.custom_minimum_size = Vector2(600,220)
	io_text.text = JSON.stringify(Game.state,"\t")
	io_text.editable = false
	modal_content.add_child(io_text)
	io_text.select_all()
	modal_content.add_child(_button("Copiar al portapapeles", func(): DisplayServer.clipboard_set(io_text.text)))
	if OS.has_feature("web"):
		modal_content.add_child(_button("Descargar archivo .json", func():
			JavaScriptBridge.download_buffer(io_text.text.to_utf8_buffer(), "aventura-del-valle.json", "application/json")))
	modal_content.add_child(_button("Volver", _close_modal))

func _import_copy() -> void:
	_modal("import", "Recuperar una copia")
	modal_content.add_child(_wrapped("Pega el texto de tu copia. Al pulsar Validar y sustituir, una copia válida reemplazará la partida actual. Puedes exportar primero desde el menú anterior.",16,MUTED))
	io_text = TextEdit.new()
	io_text.custom_minimum_size = Vector2(600,220)
	modal_content.add_child(io_text)
	io_status = _wrapped("Puedes pegar con el botón para leer la copia más reciente.", 13, MUTED)
	modal_content.add_child(io_status)
	modal_content.add_child(_button("Pegar del portapapeles", _paste_copy))
	modal_content.add_child(_button("Validar y sustituir partida", func():
		if Game.import_text(io_text.text):
			world.rebuild()
			if not Game.state.battle.is_empty():
				_show_battle()))
	modal_content.add_child(_button("Cancelar", _close_modal))

func _paste_copy() -> void:
	if not OS.has_feature("web"):
		io_text.text = DisplayServer.clipboard_get()
		io_status.text = "Texto pegado. Revisa la copia antes de sustituir la partida."
		return
	var navigator := JavaScriptBridge.get_interface("navigator")
	if navigator.clipboard == null:
		io_status.text = "El navegador no permite leer el portapapeles aquí. Pega el texto manualmente."
		return
	clipboard_callback = JavaScriptBridge.create_callback(_clipboard_received)
	clipboard_error_callback = JavaScriptBridge.create_callback(_clipboard_failed)
	io_status.text = "Leyendo el portapapeles…"
	navigator.clipboard.readText().then(clipboard_callback).catch(clipboard_error_callback)

func _clipboard_received(args: Array) -> void:
	if modal_kind != "import" or not is_instance_valid(io_text):
		return
	io_text.text = str(args[0]) if not args.is_empty() else ""
	io_status.text = "Copia recibida. Revisa el texto y pulsa Validar y sustituir."

func _clipboard_failed(_args: Array) -> void:
	if modal_kind == "import" and is_instance_valid(io_status):
		io_status.text = "No se pudo leer el portapapeles. Pega el texto manualmente; tu partida no ha cambiado."

func _input(event: InputEvent) -> void:
	if overlay and overlay.visible and event.is_action_pressed("ui_cancel") and modal_kind != "battle":
		_close_modal()
		get_viewport().set_input_as_handled()

func _process(delta: float) -> void:
	clock += delta

func _exit_tree() -> void:
	if character_panel != null:
		character_panel.screen = null
	character_panel = null
	clipboard_callback = null
	clipboard_error_callback = null
