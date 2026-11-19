extends Control

signal interact(target: String)
signal nearby(text: String)
const Maps = preload("res://scripts/expedition_maps.gd")
var enabled := true
var village_point := Vector2i(9,8)
var nearest := ""
var timer := 0.0
var factor := 1.0
var offset := Vector2.ZERO

func _ready() -> void:
	custom_minimum_size = Vector2(576,384)
	mouse_filter = Control.MOUSE_FILTER_STOP
	Expedition.changed.connect(refresh)
	refresh()

func point() -> Vector2i:
	var r: Dictionary = Expedition.state.active_run
	return village_point if r.is_empty() else Vector2i(r.x,r.y)

func region() -> String:
	return "village" if Expedition.state.active_run.is_empty() else Expedition.state.active_run.node

func refresh() -> void:
	nearest = ""
	var caption := "WASD / flechas para caminar. Acércate a un objetivo."
	for item in Maps.objects(Expedition.state):
		var p: Vector2i = item.at
		if absi(p.x-point().x) + absi(p.y-point().y) <= 1:
			nearest = item.id
			caption = "E · " + item.name
			break
	nearby.emit(caption)
	queue_redraw()

func step(d: Vector2i) -> void:
	if not enabled: return
	if Expedition.state.active_run.is_empty():
		if Maps.walkable("village",village_point+d): village_point += d
		refresh()
	else:
		Expedition.move(d)

func activate() -> void:
	if enabled and not nearest.is_empty(): interact.emit(nearest)

func _process(delta: float) -> void:
	timer -= delta
	if not enabled or timer > 0: return
	var d := Vector2i.ZERO
	if Input.is_physical_key_pressed(KEY_W) or Input.is_physical_key_pressed(KEY_UP): d = Vector2i.UP
	elif Input.is_physical_key_pressed(KEY_S) or Input.is_physical_key_pressed(KEY_DOWN): d = Vector2i.DOWN
	elif Input.is_physical_key_pressed(KEY_A) or Input.is_physical_key_pressed(KEY_LEFT): d = Vector2i.LEFT
	elif Input.is_physical_key_pressed(KEY_D) or Input.is_physical_key_pressed(KEY_RIGHT): d = Vector2i.RIGHT
	if d != Vector2i.ZERO:
		step(d)
		timer = 0.13

func _unhandled_key_input(event: InputEvent) -> void:
	if enabled and event is InputEventKey and event.pressed and not event.echo and event.physical_keycode in [KEY_E,KEY_SPACE]:
		activate()
		get_viewport().set_input_as_handled()

func _gui_input(event: InputEvent) -> void:
	if not enabled or not event is InputEventMouseButton or not event.pressed or event.button_index != MOUSE_BUTTON_LEFT: return
	var local: Vector2 = (event.position-offset)/factor
	var clicked := Vector2i(int(local.x/32),int(local.y/32))
	var diff := clicked-point()
	if absi(diff.x)+absi(diff.y) <= 1:
		if diff == Vector2i.ZERO: activate()
		else: step(diff)

func text(s: String, p: Vector2, color: Color, font_size: int = 12) -> void:
	var f := ThemeDB.fallback_font
	var w := f.get_string_size(s,HORIZONTAL_ALIGNMENT_LEFT,-1,font_size).x
	draw_string(f,p-Vector2(w/2,0),s,HORIZONTAL_ALIGNMENT_LEFT,-1,font_size,color)

func person(p: Vector2, color: Color) -> void:
	draw_circle(p+Vector2(16,27),11,Color("162f30"))
	draw_rect(Rect2(p+Vector2(7,13),Vector2(19,14)),color)
	draw_rect(Rect2(p+Vector2(10,2),Vector2(13,13)),Color("e8c4a0"))
	draw_rect(Rect2(p+Vector2(9,1),Vector2(15,5)),Color("514333"))
	draw_rect(Rect2(p+Vector2(11,26),Vector2(4,5)),Color("a9b9ac"))
	draw_rect(Rect2(p+Vector2(20,26),Vector2(4,5)),Color("a9b9ac"))

func _draw() -> void:
	factor = minf(size.x/576.0,size.y/384.0)
	offset = (size-Vector2(576,384)*factor)*0.5
	draw_set_transform(offset,0,Vector2.ONE*factor)
	var node := region()
	var blocks: Array = Maps.obstacles(node)
	for y in range(12):
		for x in range(18):
			var p := Vector2(x*32,y*32)
			var edge := x==0 or y==0 or x==17 or y==11
			var color := Color("3c604d") if (x+y)%2==0 else Color("385948")
			if y in [5,6,7]: color = Color("777455") if (x+y)%2==0 else Color("716e50")
			if node == "N6": color = color.darkened(0.18)
			draw_rect(Rect2(p,Vector2(32,32)),color)
			if edge or blocks.has(Vector2i(x,y)):
				if node=="N2A" and not edge:
					draw_rect(Rect2(p,Vector2(32,32)),Color("477c83"))
					draw_line(p+Vector2(3,14),p+Vector2(25,14),Color("78a5a2"),2)
				elif node=="N4A" and not edge:
					draw_rect(Rect2(p+Vector2(1,4),Vector2(30,27)),Color("8a9081"))
				else:
					draw_rect(Rect2(p+Vector2(14,12),Vector2(5,20)),Color("635b40"))
					draw_colored_polygon(PackedVector2Array([p+Vector2(1,25),p+Vector2(16,0),p+Vector2(31,25)]),Color("254d42"))
					draw_colored_polygon(PackedVector2Array([p+Vector2(5,14),p+Vector2(16,-3),p+Vector2(28,14)]),Color("34634b"))
	if node=="village":
		for x in [4,11]:
			var p:=Vector2(x*32,1*32)
			var restored: bool = Expedition.state.campaign.patio if x==4 else (Expedition.state.campaign.botica or Expedition.state.campaign.arsenal)
			draw_rect(Rect2(p+Vector2(0,26),Vector2(128,58)),Color("beb18b") if restored else Color("787e69"))
			draw_colored_polygon(PackedVector2Array([p+Vector2(-10,30),p+Vector2(64,-4),p+Vector2(138,30)]),Color("a57556") if restored else Color("5a6759"))
			for window_x in [18,90]:
				draw_rect(Rect2(p+Vector2(window_x,45),Vector2(18,23)),Color("e5c585") if restored else Color("344943"))
			if x==11:
				if Expedition.state.campaign.botica: text("BOTICA",p+Vector2(32,25),Color("f7e2a8"),10)
				if Expedition.state.campaign.arsenal: text("BANCO",p+Vector2(96,25),Color("f7e2a8"),10)
	for item in Maps.objects(Expedition.state):
		var p: Vector2 = Vector2(item.at)*32
		match item.kind:
			"enemy":
				var color := Color("a2bb76") if node=="N1" else (Color("b7a690") if node=="N6" else Color("b48985"))
				draw_rect(Rect2(p+Vector2(1,9),Vector2(30,22)),color)
				if node=="N6": draw_rect(Rect2(p+Vector2(5,-13),Vector2(23,26)),color)
				if node=="N4A":
					draw_colored_polygon(PackedVector2Array([p+Vector2(-9,2),p+Vector2(16,16),p+Vector2(40,2),p+Vector2(28,27),p+Vector2(3,27)]),color)
				draw_rect(Rect2(p+Vector2(8,17),Vector2(4,4)),Color("283c38"))
				draw_rect(Rect2(p+Vector2(22,17),Vector2(4,4)),Color("283c38"))
			"person": person(p,Color("d6a56a"))
			"fire":
				draw_circle(p+Vector2(16,23),16,Color("485247"))
				draw_colored_polygon(PackedVector2Array([p+Vector2(6,28),p+Vector2(15,0),p+Vector2(27,28)]),Color("f0bd70"))
			"herbs":
				for i in range(3): draw_circle(p+Vector2(8+i*8,18-i*3),6,Color("b8cc85"))
			"chest":
				draw_rect(Rect2(p+Vector2(3,10),Vector2(26,21)),Color("b18a59"))
				draw_rect(Rect2(p+Vector2(13,10),Vector2(6,17)),Color("e6ca8f"))
			_:
				draw_rect(Rect2(p+Vector2(14,11),Vector2(4,22)),Color("574734"))
				draw_rect(Rect2(p+Vector2(1,2),Vector2(30,18)),Color("d8c18d"))
				text(">" if item.kind=="exit" else "+",p+Vector2(16,16),Color("36463d"),16)
		if nearest==item.id: draw_arc(p+Vector2(16,27),20,0,TAU,24,Color("ffe0a0"),2)
		text(item.name,p+Vector2(16,-17 if node=="N6" and item.kind=="enemy" else -5),Color("f4e7bf"),11)
	var cls: String = Expedition.state.campaign["class"] if Expedition.state.active_run.is_empty() else Expedition.state.active_run["class"]
	person(Vector2(point())*32,{"guardian":Color("8bc7ad"),"assassin":Color("d8bb75"),"mage":Color("bba0ce")}.get(cls,Color.WHITE))
	draw_set_transform(Vector2.ZERO)
