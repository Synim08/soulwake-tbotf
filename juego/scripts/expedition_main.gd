extends Control

const Rules = preload("res://scripts/expedition_rules.gd")
const Maps = preload("res://scripts/expedition_maps.gd")
const World = preload("res://scripts/expedition_world.gd")
const HUDScene = preload("res://hud/compact_hud.tscn")
const HudAdapter = preload("res://scripts/expedition_hud_adapter.gd")
const INK := Color("e7ecdf")
const GOLD := Color("e9ca8e")
const MUTED := Color("a5b7b0")
const CLASS_NAMES := {"guardian":"Guerrero · Guardián", "assassin":"Asesino · Duelista", "mage":"Mago · Piromante"}
const CLASS_HELP := {"guardian":"Defender devuelve 3 de daño si recibes un golpe.","assassin":"Cada tercer ataque básico es crítico. Sigue el contador.","mage":"Chispa aplica quemadura; las brasas dañan durante varias acciones."}
const NODE_HELP := {"N1":"Combate moderado · Slime. Mejora y 2 madera.","N2A":"Ruta segura · Hierbas: curarte o recoger madera.","N2B":"Riesgo · Lobo. 2 mineral, sin curación.","N3":"Descanso único · 10 PV o 6 PM.","N4A":"Ruta moderada · Murciélago. Mara y materiales.","N4B":"Riesgo alto · Lobo veterano. Más mineral y arma.","N5":"Preparación · Alijo y mejora antes del jefe.","N6":"Jefe · Sin retirada durante el combate. Materiales y desbloqueo."}
const UPGRADE_TEXT := {
	"G01":["Escudo de espinas","+2 al daño devuelto al defender."],"G02":["Golpe preparado","Defender prepara +3 para tu siguiente ataque; no acumula cargas."],"G03":["Sello del vigía","+1 PM al defender."],
	"A01":["Filo certero","Multiplicador crítico +0,5."],"A02":["Paso ligero","Al atacar, recibes 2 de daño menos en la respuesta enemiga."],"A03":["Ritmo mortal","Crítico cada 2 ataques en vez de cada 3."],
	"M01":["Ascua persistente","Quemadura dura una acción adicional."],"M02":["Canalización","Chispa cuesta 1 PM menos."],"M03":["Núcleo ardiente","+1 daño por activación de quemadura."],
	"C01":["Cantimplora","Recupera 2 PV tras cada victoria de combate."],"C02":["Bolsa de vendas","Las pociones curan 4 PV más."],"C03":["Reserva arcana","+3 PM máximos; recupera 3 PM ahora."]}
var world
var hud
var location_timer: Timer
var last_location := ""
var place: Label
var notices: Label
var nearby: Label
var overlay: ColorRect
var content: VBoxContainer
var mode := ""
var io_text: TextEdit
var io_status: Label
var confirm_action: Callable
var confirm_title := ""
var confirm_body := ""
var clipboard_callback: JavaScriptObject
var clipboard_error_callback: JavaScriptObject

func box(bg: String = "20363a") -> StyleBoxFlat:
	var b := StyleBoxFlat.new()
	b.bg_color = Color(bg)
	b.border_color = Color("50685e")
	b.set_border_width_all(1)
	b.set_corner_radius_all(8)
	b.content_margin_left = 14
	b.content_margin_right = 14
	b.content_margin_top = 10
	b.content_margin_bottom = 10
	return b

func label_text(text: String, size: int = 16, color: Color = INK) -> Label:
	var l := Label.new()
	l.text = text
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.add_theme_font_size_override("font_size",size)
	l.add_theme_color_override("font_color",color)
	return l

func button(text: String, callback: Callable, disabled: bool = false) -> Button:
	var b := Button.new()
	b.text = text
	b.custom_minimum_size.y = 43
	b.disabled = disabled
	b.pressed.connect(callback)
	return b

func _ready() -> void:
	var t := Theme.new()
	t.default_font_size = 16
	t.set_stylebox("normal","Button",box())
	t.set_stylebox("hover","Button",box("354f4b"))
	t.set_stylebox("pressed","Button",box("13292c"))
	t.set_stylebox("disabled","Button",box("263132"))
	t.set_color("font_color","Button",INK)
	t.set_color("font_disabled_color","Button",Color("85938c"))
	var focus := box("20363a")
	focus.bg_color = Color(0,0,0,0)
	focus.border_color = GOLD
	focus.set_border_width_all(2)
	t.set_stylebox("focus","Button",focus)
	t.set_stylebox("panel","PanelContainer",box("182d32"))
	t.set_stylebox("normal","TextEdit",box("11262c"))
	t.set_color("font_color","TextEdit",INK)
	theme = t
	var bg := ColorRect.new()
	bg.color = Color("0f2027")
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	world = World.new()
	world.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	world.offset_left = 18
	world.offset_right = -18
	world.offset_top = 170
	world.offset_bottom = -110
	add_child(world)
	world.interact.connect(_interact)
	hud = HUDScene.instantiate()
	hud.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(hud)
	hud.map_requested.connect(func():
		if mode.is_empty() and not Expedition.blocked: open_menu("map"))
	hud.menu_requested.connect(func():
		if mode.is_empty(): open_menu("pause"))
	hud.potion_requested.connect(_request_potion)
	hud.bag_toggled.connect(func(_open: bool): _update_world_enabled())
	place = label_text("",19,GOLD)
	place.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	place.offset_top = 145
	place.offset_bottom = 171
	place.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	place.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(place)
	location_timer = Timer.new()
	location_timer.one_shot = true
	location_timer.wait_time = 3.5
	location_timer.timeout.connect(func(): place.hide())
	add_child(location_timer)
	nearby = label_text("",16,GOLD)
	nearby.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	nearby.offset_top = -103
	nearby.offset_bottom = -72
	nearby.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	nearby.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(nearby)
	world.nearby.connect(func(text: String): nearby.text = text if not world.nearest.is_empty() else "")
	notices = label_text("",15,GOLD)
	notices.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	notices.offset_left = 20
	notices.offset_right = -20
	notices.offset_top = -140
	notices.offset_bottom = -105
	notices.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	notices.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(notices)
	overlay = ColorRect.new()
	overlay.color = Color(0.025,0.07,0.085,0.94)
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(overlay)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.add_child(center)
	var modal_panel := PanelContainer.new()
	modal_panel.custom_minimum_size = Vector2(690,640)
	center.add_child(modal_panel)
	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(660,610)
	modal_panel.add_child(scroll)
	content = VBoxContainer.new()
	content.custom_minimum_size.x = 635
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation",12)
	scroll.add_child(content)
	Expedition.changed.connect(_sync)
	_sync()

func _sync() -> void:
	var s: Dictionary = Expedition.state
	var c: Dictionary = s.campaign
	var r: Dictionary = s.active_run
	hud.set_state(HudAdapter.present(s))
	var location: String = Maps.TITLES.get("village" if r.is_empty() else r.node, "Bosque del Sendero")
	if location != last_location:
		last_location = location
		place.text = location
		place.show()
		location_timer.start()
	notices.text = Expedition.notice
	if mode not in ["io","export","import","confirm","help"]:
		if not r.is_empty() and not r.battle.is_empty(): mode = "battle"
		elif not r.is_empty() and not r.pending_offer.is_empty(): mode = "offer"
		elif not s.last_result.is_empty() and not s.last_result.get("ack",true): mode = "result"
		elif mode in ["battle","offer","result"]: mode = ""
	hud.visible = mode.is_empty()
	hud.process_mode = Node.PROCESS_MODE_INHERIT if mode.is_empty() else Node.PROCESS_MODE_DISABLED
	if not mode.is_empty(): hud.set_bag_open(false)
	_update_world_enabled()
	world.refresh()
	overlay.visible = not mode.is_empty()
	if overlay.visible: _render_menu()

func open_menu(next: String) -> void:
	mode = next
	_sync()

func close_menu() -> void:
	mode = ""
	_sync()

func act(action: String, value: String = "") -> void:
	mode = "prepare" if action in ["patio","class","kit","weapon"] else ("projects" if action=="build" else "")
	Expedition.execute(action,value)

func heading(s: String) -> void: content.add_child(label_text(s,24,GOLD))
func paragraph(s: String) -> void: content.add_child(label_text(s,16,MUTED))
func option(s: String, callback: Callable, disabled: bool = false) -> void: content.add_child(button(s,callback,disabled))

func _render_menu() -> void:
	for child in content.get_children():
		content.remove_child(child)
		child.queue_free()
	var s: Dictionary = Expedition.state
	var c: Dictionary = s.campaign
	var r: Dictionary = s.active_run
	match mode:
		"pause":
			heading("Menú de expediciones")
			paragraph(CLASS_NAMES[c["class"] if r.is_empty() else r["class"]])
			option("Continuar",close_menu)
			option("Mapa de rutas",func(): open_menu("map"),Expedition.blocked)
			option("Preparar personaje",func(): open_menu("prepare"),Expedition.blocked)
			option("Proyectos del pueblo",func(): open_menu("projects"),Expedition.blocked)
			option("Regresar con los materiales",_retreat,r.is_empty() or not Rules.ready_to_leave(r) or Expedition.blocked)
			option("Partida y copias",func(): open_menu("io"))
			option("Cómo jugar",func(): open_menu("help"))
		"prepare":
			heading("Patio de aventureros")
			if not r.is_empty():
				paragraph("La especialización y el equipo inicial se cambian al regresar al pueblo.")
			elif not c.patio:
				paragraph("Reabre gratuitamente los tres puestos de entrenamiento. Cada edificio del pueblo ofrece nuevas opciones para tus aventuras.")
				option("Habilitar Patio de aventureros · gratis",act.bind("patio"))
			else:
				for cls in ["guardian","assassin","mage"]:
					option(("Elegido: " if c["class"]==cls else "Elegir: ")+CLASS_NAMES[cls],act.bind("class",cls))
					paragraph(CLASS_HELP[cls])
				paragraph("Preparación gratuita · 38 PV / 12 PM\nKit normal: 2 pociones de 22 PV.")
				if c.botica:
					option("Kit normal"+(" · elegido" if c.kit=="normal" else ""),act.bind("kit","normal"))
					option("Kit fraccionado: 3 tónicos de 12 PV"+(" · elegido" if c.kit=="small" else ""),act.bind("kit","small"))
				if c.arsenal:
					paragraph(_weapon_description(c["class"],"tactical"))
					option("Arma básica"+(" · elegida" if c.weapon=="basic" else ""),act.bind("weapon","basic"))
					option("Arma táctica"+(" · elegida" if c.weapon=="tactical" else ""),act.bind("weapon","tactical"))
				paragraph("Si caes, pierdes todos los materiales de esta expedición. Puedes regresar desde un lugar despejado. En combate debes vencer para continuar.")
				option("Iniciar expedición · Bosque del Sendero",act.bind("start"))
			option("Volver",close_menu)
		"projects":
			heading("Reconstruir Refugio del Alba")
			paragraph("Almacén: %d madera / %d mineral. Los materiales ya depositados permanecen aunque caigas." % [c.wood,c.ore])
			paragraph("Botica de campaña · 4 madera + 2 mineral y rescatar a Mara. Abre el kit fraccionado de 3 tónicos de 12 PV.")
			option("Botica construida" if c.botica else "Reconstruir botica",func(): confirm("Reconstruir botica","Gastar 4 madera y 2 mineral del almacén.",act.bind("build","botica")), c.botica or not r.is_empty() or not c.mara or c.wood<4 or c.ore<2)
			paragraph("Banco de equipo · 8 madera + 6 mineral y vencer al guardián. Abre armas tácticas iniciales de tu especialización.")
			option("Banco construido" if c.arsenal else "Reconstruir banco de equipo",func(): confirm("Reconstruir banco","Gastar 8 madera y 6 mineral del almacén.",act.bind("build","arsenal")),c.arsenal or not r.is_empty() or not c.boss or c.wood<8 or c.ore<6)
			paragraph("Mara: "+("en el pueblo" if c.mara else "refugiada en las ruinas")+"\nGuardián: "+("vencido" if c.boss else "pendiente"))
			option("Volver",close_menu)
		"map": _map_menu(r)
		"battle": _battle_menu(r)
		"offer":
			heading("Elige tu recompensa")
			if r.pending_offer=="E1": paragraph("Al aceptar pagarás 8 PV. Rechazar no cuesta vida.")
			paragraph("Solo sirve durante esta expedición. La oferta se conserva al guardar y reanudar.")
			if r.pending_offer=="W1": paragraph("Arma actual: "+{"basic":"básica","power":"de potencia","tactical":"táctica"}[r.weapon]+". La nueva la reemplaza; sus bonificaciones no se acumulan con la descartada.")
			for id in Rules.offer_options(r):
				if r.pending_offer=="W1":
					paragraph(_weapon_description(r["class"],id))
					option("Equipar variante "+("de potencia" if id=="power" else "táctica"),act.bind("choose",id))
				else:
					var info: Array = UPGRADE_TEXT.get(id,[id,""])
					paragraph(info[1])
					option(info[0],act.bind("choose",id))
			option("Conservar arma actual" if r.pending_offer=="W1" else "Rechazar mejoras",act.bind("skip"))
			option("Partida y copias",func(): open_menu("io"))
		"result":
			var result: Dictionary = s.last_result
			heading({"won":"El sendero vuelve a abrirse","lost":"Has caído","retired":"Has regresado a salvo"}.get(result.outcome,"Regreso"))
			paragraph("Depositado: %d madera / %d mineral\nPerdido: %d madera / %d mineral" % [result.wood,result.ore,result.lost_wood,result.lost_ore])
			paragraph("El equipo temporal termina aquí. Tus edificios y lo que ya guardaste en el pueblo permanecen.")
			if result.get("traveler",false): paragraph("El viajero regresó a salvo: sus 3 madera y 2 mineral están incluidos en el depósito.")
			if result.mara: paragraph("Mara llegó al pueblo. Ya puedes reconstruir la botica.")
			if result.boss: paragraph("Venciste al guardián. El Banco de equipo está disponible para reconstruir.")
			option("Volver al pueblo",act.bind("ack"))
		"event":
			heading(Rules.event_name(r))
			match r.variation.event:
				"merchant":
					paragraph("Intercambia 2 madera o 2 mineral de la mochila por un suministro de tu kit. Máximo: 3. Un solo intercambio.")
					option("Entregar 2 madera",act.bind("event","wood"),r.bag.wood<2 or r.potions>=3)
					option("Entregar 2 mineral",act.bind("event","ore"),r.bag.ore<2 or r.potions>=3)
				"altar":
					paragraph("Ofrece 8 PV por una mejora temporal compatible. No puede matarte. Verás la oferta antes de pagar; rechazarla no cuesta vida.")
					option("Examinar la ofrenda",act.bind("event","accept"),r.hp<=8)
				"traveler":
					paragraph("Entrega un suministro para ayudarlo. Si regresas por retirada o victoria, recibes 3 madera y 2 mineral. Si caes, no recibes nada.")
					option("Ayudar con un suministro",act.bind("event","help"),r.potions<1)
			option("Declinar y seguir",act.bind("event","leave"))
			option("Volver sin decidir",close_menu)
		"herbs":
			heading("Hierbas de ribera")
			paragraph("Elige una sola opción. La decisión queda resuelta para esta salida.")
			option("Curarte hasta 8 PV",act.bind("interact","event_heal"),r.hp>=38)
			option("Recoger 2 madera",act.bind("interact","event_wood"))
			option("Seguir sin recoger",act.bind("skip"))
		"fire":
			heading("El fuego del campamento")
			paragraph("Un solo descanso por expedición. No restaura todos tus suministros.")
			option("Recuperar hasta 10 PV",act.bind("interact","rest_hp"),r.hp>=38)
			option("Recuperar hasta 6 PM",act.bind("interact","rest_mp"),r.mp>=r.max_mp)
			option("Continuar sin descansar",act.bind("skip"))
		"confirm":
			heading(confirm_title)
			paragraph(confirm_body)
			option("Confirmar",confirm_action)
			option("Cancelar",close_menu)
		"io","export","import": _io_menu()
		"help":
			heading("Una expedición, muchas decisiones")
			paragraph("WASD / flechas: caminar. E / Espacio: interactuar cerca de un objetivo. M abre el mapa; Escape abre el menú; Q usa una poción en combate. La mochila muestra su detalle al pulsarla.\n\nCamina al cartel de salida y consulta el mapa para avanzar. Cada cruce se elige una sola vez. Recoge cofres y habla con personajes.\n\nEn combate, lee la intención. Defender reduce el daño y recupera PM; Chispa aplica quemadura solo al Piromante. No hay huida durante el combate.\n\nRetirarte desde un lugar despejado deposita tu mochila. Caer la pierde toda. Los rescates se consolidan si vuelves a salvo.\n\nEl juego guarda al actuar y al caminar. Cerrar suspende la misma expedición. No hay ingresos offline. Arte provisional y sin audio en esta entrega.")
			option("Volver",close_menu)
	if not Expedition.notice.is_empty() and mode!="help": paragraph(Expedition.notice)

func _weapon_description(cls: String, id: String) -> String:
	if id=="power": return "Potencia: +2 ataque respecto al arma básica." if cls!="mage" else "Bastón incandescente: +2 daño directo de Chispa respecto al básico."
	return {"guardian":"Hoja del vigía: ataque básico y +2 daño devuelto al defender.","assassin":"Dagas de precisión: ataque básico y multiplicador crítico +0,5.","mage":"Bastón de rescoldos: estadísticas básicas y +1 duración de quemadura."}[cls]

func _map_menu(r: Dictionary) -> void:
	heading("Bosque del Sendero · Rutas")
	paragraph("Entrada > Claro de savia > Ribera / Linde > Campamento > Ruinas / Tala > Umbral > Guardián")
	if r.is_empty():
		paragraph("Prepara el personaje en el Patio de aventureros para salir. Cada destino es un pequeño escenario explorable.")
	else:
		var visited_names: Array[String] = []
		for node in r.visited: visited_names.append(Maps.TITLES[node])
		paragraph("Tu recorrido: "+" > ".join(visited_names)+"\nActual: "+Maps.TITLES[r.node])
		var available: Array = Rules.choices(Expedition.state)
		if available.is_empty(): paragraph("Despeja el encuentro o resuelve la recompensa antes de seguir.")
		for node in available:
			paragraph(NODE_HELP.get(node,""))
			if not Rules.encounter_name(r,node).is_empty(): paragraph("Encuentro de esta salida: "+Rules.encounter_name(r,node))
			if node=="N3" and r.has("variation"): paragraph("Evento opcional: "+Rules.event_name(r))
			var at_exit: bool = world.nearest=="exit"
			option("Avanzar: "+Maps.TITLES[node],func():
				if node in ["N4B","N6"]: confirm("Entrar en zona peligrosa",NODE_HELP[node]+"\nEn combate no podrás retirarte.",act.bind("travel",node))
				else: act("travel",node),not at_exit)
		if not available.is_empty() and world.nearest!="exit": paragraph("Acércate al cartel del este para avanzar por una ruta.")
	option("Volver",close_menu)

func _battle_menu(r: Dictionary) -> void:
	if r.is_empty() or r.battle.is_empty(): return
	var b: Dictionary = r.battle
	heading("Combate · "+Rules.encounter_name(r,r.node))
	paragraph("Enemigo: %d / %d PV · Guardia %s\nTu vida: %d/38 · Maná: %d/%d · Pociones: %d" % [b.hp,b.max_hp,"activa" if b.guard else "inactiva",r.hp,r.mp,r.max_mp,r.potions])
	var intent := label_text("INTENCIÓN: "+Rules.intention(Expedition.state),19,GOLD)
	intent.custom_minimum_size.y = 64
	intent.max_lines_visible = 2
	content.add_child(intent)
	var log_text := label_text("Quemadura: %d acciones · Contador crítico: %d\n%s" % [b.burn_turns,b.focus,b.message],16,MUTED)
	log_text.custom_minimum_size.y = 112
	log_text.max_lines_visible = 4
	content.add_child(log_text)
	var row := GridContainer.new()
	row.columns = 2
	content.add_child(row)
	for pair in [["Atacar","attack"],["Chispa","magic"],["Defender · recupera PM","defend"],["Poción [Q]","potion"]]:
		var bt := button(pair[0],act.bind(pair[1]), (pair[1]=="magic" and r.mp<Rules.stats(r).magic_cost) or (pair[1]=="potion" and (r.potions<=0 or r.hp>=38)))
		bt.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(bt)
	paragraph("No hay huida durante el combate. Las acciones inválidas no consumen turno.")
	option("Partida y copias",func(): open_menu("io"))

func confirm(title: String, body: String, callback: Callable) -> void:
	confirm_title = title
	confirm_body = body
	confirm_action = callback
	open_menu("confirm")

func _retreat() -> void:
	if Expedition.state.active_run.is_empty(): return
	confirm("Regresar al pueblo","Conservarás los materiales de la mochila. El equipo y las mejoras temporales terminarán aquí. Solo puedes regresar desde un lugar despejado.",act.bind("retreat"))

func _interact(target: String) -> void:
	match target:
		"prepare","depart": open_menu("prepare")
		"projects": open_menu("projects")
		"exit": open_menu("map")
		"herbs","fire": open_menu(target)
		"encounter_event": open_menu("event")
		"enemy":
			confirm("Entrar en combate", "Debes vencer este encuentro para despejar el lugar. No podrás retirarte durante el combate.",act.bind("interact","enemy"))
		_: act("interact",target)

func _io_menu() -> void:
	heading("Partida de expediciones")
	if mode=="io":
		paragraph("Esta campaña usa su propio guardado. La versión incremental 0.2 sigue en su ranura. Exporta una copia antes de importar otra o borrar datos del navegador.")
		option("Guardar ahora",func(): Expedition.flush(); close_menu())
		option("Exportar copia",func(): open_menu("export"))
		option("Importar copia",func(): open_menu("import"))
		option("Volver",close_menu)
	else:
		paragraph("Copia JSON de la campaña y la expedición en curso." if mode=="export" else "Pega una copia del modo Expediciones. Una copia válida sustituirá la partida de este modo; exporta antes la actual para conservar ambas.")
		io_text = TextEdit.new()
		io_text.custom_minimum_size = Vector2(610,240)
		io_text.editable = mode=="import"
		if mode=="export": io_text.text = JSON.stringify(Expedition.state,"\t")
		content.add_child(io_text)
		io_status = label_text("",14,GOLD)
		content.add_child(io_status)
		if mode=="export":
			option("Copiar al portapapeles",func(): DisplayServer.clipboard_set(io_text.text); io_status.text="Copia preparada.")
			if OS.has_feature("web"): option("Descargar archivo JSON",func(): JavaScriptBridge.download_buffer(io_text.text.to_utf8_buffer(),"aventura-expediciones.json","application/json"))
		else:
			option("Pegar del portapapeles",_paste)
			option("Validar y sustituir partida",func():
				var incoming: String = io_text.text
				if Expedition.import_text(incoming): close_menu()
				else:
					io_text.text=incoming
					io_status.text=Expedition.notice)
		option("Volver",close_menu)

func _paste() -> void:
	if not OS.has_feature("web"):
		io_text.text = DisplayServer.clipboard_get()
		return
	var navigator := JavaScriptBridge.get_interface("navigator")
	if navigator.clipboard==null:
		io_status.text="Pega el texto manualmente; el navegador no permite leer el portapapeles."
		return
	clipboard_callback = JavaScriptBridge.create_callback(func(args: Array):
		if mode=="import" and is_instance_valid(io_text): io_text.text=str(args[0]))
	clipboard_error_callback = JavaScriptBridge.create_callback(func(_args: Array):
		if mode=="import" and is_instance_valid(io_status): io_status.text="No se pudo leer. Pega la copia manualmente.")
	navigator.clipboard.readText().then(clipboard_callback).catch(clipboard_error_callback)

func _update_world_enabled() -> void:
	world.enabled = mode.is_empty() and not Expedition.blocked and not hud.get_node("BagPopup").visible

func _request_potion() -> void:
	var run: Dictionary = Expedition.state.active_run
	if mode == "battle" and not run.is_empty() and not run.battle.is_empty():
		act("potion")

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and not event.ctrl_pressed and not event.alt_pressed and not event.meta_pressed and mode == "battle" and event.physical_keycode == KEY_Q:
		_request_potion()
		get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed("ui_cancel") and not mode.is_empty() and mode not in ["battle","offer","result"]:
		close_menu()
		get_viewport().set_input_as_handled()
