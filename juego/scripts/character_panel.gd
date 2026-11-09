extends RefCounted

const Builds = preload("res://scripts/build_rules.gd")
var screen

func _init(owner_screen) -> void:
	screen = owner_screen

func show_panel(tab: String = "talents") -> void:
	if not Game.state.battle.is_empty():
		screen._show_battle()
		return
	if Game.state.region != "village":
		screen._show_message("Puedes cambiar tu estilo, talentos y equipo en el pueblo. Volver al pueblo no tiene coste.")
		return
	var state: Dictionary = Game.state
	var style: String = state.active_style
	var selected := Builds.selected(state)
	var stats := Builds.stats(state)
	screen._modal("character", "Tu forma de aventurarte")
	var content: VBoxContainer = screen.modal_content
	var styles := HBoxContainer.new()
	styles.add_theme_constant_override("separation", 8)
	content.add_child(styles)
	for id in Builds.STYLES:
		var chosen: String = id
		var button: Button = screen._button(("[Activo] " if style == id else "") + Builds.STYLES[id].name, func():
			Game.configure_character(chosen)
			show_panel(tab))
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		styles.add_child(button)
	content.add_child(screen._wrapped("Ataque %d · Chispa %d de daño / %d PM · Defender recupera %d PM\nCambios gratis en el pueblo. Cada estilo conserva su talento y equipo." % [stats.attack, stats.magic, stats.magic_cost, stats.guard_mp], 14, screen.GREEN))
	var tabs := HBoxContainer.new()
	tabs.add_theme_constant_override("separation", 8)
	content.add_child(tabs)
	for pair in [["Estilo y talento", "talents"], ["Equipo", "gear"], ["Entrenamiento", "practice"]]:
		var next_tab: String = pair[1]
		var button: Button = screen._button(pair[0], func(): show_panel(next_tab))
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tabs.add_child(button)
	match tab:
		"talents":
			content.add_child(screen._wrapped(Builds.STYLES[style].description, 17))
			content.add_child(screen._label("ELIGE UN TALENTO · uno activo", 12, screen.GOLD))
			for id in Builds.STYLES[style].talents:
				var talent: String = id
				content.add_child(screen._button(("[Elegido] " if selected.talent == id else "") + Builds.TALENTS[id].name, func():
					Game.configure_character(style, "talent", talent)
					show_panel(tab)))
				content.add_child(screen._wrapped(Builds.TALENTS[id].description, 14, screen.MUTED))
		"gear":
			_equipment_row("Arma", "weapon", Builds.WEAPONS, state.flags.sword)
			content.add_child(screen._wrapped(Builds.GEAR[selected.weapon].description, 16))
			_equipment_row("Reliquia", "relic", Builds.RELICS, state.flags.boss_defeated)
			content.add_child(screen._wrapped(Builds.GEAR[selected.relic].description, 16))
			content.add_child(screen._wrapped("Al fabricar la espada se preparan también el bastón y el arco para probar configuraciones. Las reliquias se desbloquean al vencer al guardián. Las bonificaciones de quemadura requieren el estilo Mago.", 14, screen.MUTED))
		"practice":
			content.add_child(screen._wrapped("Prueba tu configuración sin alterar la historia. Empiezas con 38 PV, 12 PM y 3 pociones de práctica. Al terminar recuperas tus suministros anteriores. No hay monedas ni desbloqueos de misión.", 16))
			for type in ["slime", "wolf", "bat", "guardian"]:
				var target: String = type
				var button: Button = screen._button("Entrenar · " + Game.enemies[type].display_name, func():
					if Game.start_practice(target):
						screen._show_battle())
				button.disabled = type == "guardian" and not state.flags.boss_defeated
				content.add_child(button)
	content.add_child(screen._button("Volver a la aventura", screen._close_modal))
	styles.get_child(Builds.STYLES.keys().find(style)).grab_focus()

func _equipment_row(label: String, field: String, ids: Array, unlocked: bool) -> void:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	screen.modal_content.add_child(row)
	row.add_child(screen._label(label, 17, screen.GOLD))
	var select := OptionButton.new()
	select.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	select.custom_minimum_size.y = 42
	row.add_child(select)
	var current: Dictionary = Builds.selected(Game.state)
	for id in ids:
		var index := select.item_count
		select.add_item(Builds.GEAR[id].display_name)
		select.set_item_disabled(index, index > 0 and not unlocked)
		if id == current[field]:
			select.select(index)
	select.item_selected.connect(func(index: int):
		Game.configure_character(Game.state.active_style, field, ids[index])
		show_panel("gear"))
