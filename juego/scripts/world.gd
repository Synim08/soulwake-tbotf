extends Node2D

signal nearby_changed(text: String)
signal interaction_requested(object: Dictionary)

const Regions = preload("res://scripts/regions.gd")
const TILE := 32
var region := ""
var layer: TileMapLayer
var visual := Vector2.ZERO
var step_timer := 0.0
var enabled := true
var nearest: Dictionary = {}
var animation := 0.0

func _ready() -> void:
	var source := TileSetAtlasSource.new()
	source.texture = preload("res://assets/terrain.png")
	source.texture_region_size = Vector2i(16, 16)
	for i in range(8):
		source.create_tile(Vector2i(i, 0))
	var tiles := TileSet.new()
	tiles.tile_size = Vector2i(16, 16)
	tiles.add_source(source, 0)
	layer = TileMapLayer.new()
	layer.tile_set = tiles
	layer.show_behind_parent = true
	layer.scale = Vector2(2, 2)
	add_child(layer)
	rebuild()

func rebuild() -> void:
	region = Game.state.region
	layer.clear()
	for y in range(Regions.SIZE.y):
		for x in range(Regions.SIZE.x):
			layer.set_cell(Vector2i(x, y), 0, Vector2i(Regions.tile(region, Vector2i(x, y)), 0))
	visual = Vector2(Game.state.x, Game.state.y) * TILE
	_find_nearest()
	queue_redraw()

func _process(delta: float) -> void:
	var viewport_size := get_viewport_rect().size
	var factor := minf(viewport_size.x / 768.0, viewport_size.y / 544.0)
	scale = Vector2(factor, factor)
	position = (viewport_size - Vector2(768, 544) * factor) * 0.5
	if region != Game.state.region:
		rebuild()
	animation += delta
	visual = visual.move_toward(Vector2(Game.state.x, Game.state.y) * TILE, 220.0 * delta)
	step_timer -= delta
	if enabled and Game.state.battle.is_empty() and step_timer <= 0 and visual.distance_to(Vector2(Game.state.x, Game.state.y) * TILE) < 0.5:
		var direction := Vector2i.ZERO
		if Input.is_action_pressed("move_up"):
			direction = Vector2i.UP
		elif Input.is_action_pressed("move_down"):
			direction = Vector2i.DOWN
		elif Input.is_action_pressed("move_left"):
			direction = Vector2i.LEFT
		elif Input.is_action_pressed("move_right"):
			direction = Vector2i.RIGHT
		if direction != Vector2i.ZERO:
			move(direction)
	queue_redraw()

func move(direction: Vector2i) -> void:
	if not enabled or not Game.state.battle.is_empty():
		return
	var target := Vector2i(Game.state.x, Game.state.y) + direction
	if Regions.walkable(region, target, Game.state.defeated):
		Game.state.x = target.x
		Game.state.y = target.y
		step_timer = 0.12
		_find_nearest()

func _unhandled_input(event: InputEvent) -> void:
	if enabled and event.is_action_pressed("interact"):
		interact_nearby()

func interact_nearby() -> void:
	if enabled and not nearest.is_empty() and Game.state.battle.is_empty():
		interaction_requested.emit(nearest)

func _find_nearest() -> void:
	nearest = {}
	var point := Vector2i(Game.state.x, Game.state.y)
	for obj in Regions.objects(region):
		if obj.kind == "enemy" and Game.state.defeated.has(obj.id):
			continue
		var distance: int = absi(obj.at.x - point.x) + absi(obj.at.y - point.y)
		if distance <= 1:
			nearest = obj
			break
	nearby_changed.emit("E · " + nearest.label if not nearest.is_empty() else "Acércate a un personaje, edificio o sendero.")

func refresh() -> void:
	if region != Game.state.region:
		rebuild()
	_find_nearest()
	queue_redraw()

func _draw() -> void:
	if region.is_empty():
		return
	for point in Regions.trees(region):
		_tree(Vector2(point) * TILE)
	if region == "village":
		_building()
	for obj in Regions.objects(region):
		if obj.kind == "enemy" and Game.state.defeated.has(obj.id):
			continue
		var p: Vector2 = Vector2(obj.at) * TILE
		match obj.kind:
			"person":
				_person(p, {"elder": Color("ac88bb"), "mara": Color("d69c57"), "ivo": Color("829eb3")}.get(obj.id, Color.WHITE))
			"fire":
				draw_circle(p + Vector2(16, 22), 15, Color("42433c"))
				draw_rect(Rect2(p + Vector2(6, 25), Vector2(23, 4)), Color("a6784e"))
				draw_colored_polygon(PackedVector2Array([p+Vector2(9,24), p+Vector2(14,8), p+Vector2(20,17), p+Vector2(24,24)]), Color("f2b35c"))
			"beacon":
				draw_rect(Rect2(p+Vector2(5,-27), Vector2(22,57)), Color("969484"))
				draw_rect(Rect2(p+Vector2(2,-30), Vector2(28,6)), Color("c9bea0"))
				draw_circle(p+Vector2(16,-20), 7, Color("ffd889") if Game.state.flags.beacon else Color("414b50"))
			"crate":
				draw_rect(Rect2(p+Vector2(3,9), Vector2(27,20)), Color("9a7151"))
				draw_rect(Rect2(p+Vector2(13,5), Vector2(7,15)), Color("bd6072"))
			"ore":
				draw_circle(p+Vector2(16,20), 14, Color("657480"))
				draw_rect(Rect2(p+Vector2(11,9), Vector2(6,8)), Color("d1b07b"))
			"portal":
				draw_rect(Rect2(p+Vector2(14,14), Vector2(4,18)), Color("614e3c"))
				draw_rect(Rect2(p+Vector2(2,5), Vector2(28,13)), Color("dfc48b"))
				_label("<" if obj.to == "village" or region == "mine" else ">", p+Vector2(11,16), 13, Color("473e34"))
			"enemy":
				_enemy(p, obj.enemy)
		if not nearest.is_empty() and nearest.id == obj.id:
			draw_arc(p+Vector2(16,27), 19, 0, TAU, 24, Color("edcf8c"), 2)
		if obj.kind in ["person", "portal"]:
			_label(obj.label, p+Vector2(16, -6), 11, Color("f1e8ca"), true)
	_person(visual, Color("7ebda6"), true)
	if Game.state.flags.beacon and region == "village":
		for i in range(8):
			var p := Vector2(18.5*32, 4.4*32) + Vector2(sin(animation+i)*28, -fmod(animation*14+i*12,65))
			draw_rect(Rect2(p,Vector2(3,3)),Color("f4d998"))

func _label(text: String, at: Vector2, size: int, color: Color, center: bool = false) -> void:
	var font := ThemeDB.fallback_font
	var width := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, size).x
	var pos := at - Vector2(width * 0.5 if center else 0, 0)
	draw_string(font, pos+Vector2(1,1), text, HORIZONTAL_ALIGNMENT_LEFT, -1, size, Color("172426"))
	draw_string(font, pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, size, color)

func _tree(p: Vector2) -> void:
	draw_ellipse_shadow(p+Vector2(16,26),Vector2(14,5))
	draw_rect(Rect2(p+Vector2(13,9),Vector2(6,23)),Color("6e5540"))
	draw_colored_polygon(PackedVector2Array([p+Vector2(-2,21),p+Vector2(16,-14),p+Vector2(34,21)]),Color("254d44"))
	draw_colored_polygon(PackedVector2Array([p+Vector2(2,9),p+Vector2(16,-17),p+Vector2(29,9)]),Color("356951"))
	draw_line(p+Vector2(14,-9),p+Vector2(6,8),Color("54845b"),3)

func draw_ellipse_shadow(p: Vector2, radius: Vector2) -> void:
	draw_set_transform(p,0,radius)
	draw_circle(Vector2.ZERO,1,Color(0,0,0,0.16))
	draw_set_transform(Vector2.ZERO)

func _person(p: Vector2, coat: Color, hero: bool = false) -> void:
	draw_ellipse_shadow(p+Vector2(16,29),Vector2(11,4))
	draw_rect(Rect2(p+Vector2(9,22),Vector2(5,8)),Color("293c40"))
	draw_rect(Rect2(p+Vector2(19,22),Vector2(5,8)),Color("293c40"))
	draw_rect(Rect2(p+Vector2(7,11),Vector2(19,14)),coat)
	draw_rect(Rect2(p+Vector2(10,1),Vector2(13,13)),Color("e5bf96"))
	draw_rect(Rect2(p+Vector2(9,0),Vector2(15,5)),Color("4b3d35"))
	draw_rect(Rect2(p+Vector2(13,7),Vector2(2,2)),Color("26383a"))
	draw_rect(Rect2(p+Vector2(20,7),Vector2(2,2)),Color("26383a"))
	if hero:
		draw_rect(Rect2(p+Vector2(24,11),Vector2(3,15)),Color("d5d8ca"))
		draw_rect(Rect2(p+Vector2(21,19),Vector2(9,3)),Color("d6b76d"))

func _enemy(p: Vector2, type: String) -> void:
	var color: Color = Game.enemies[type].tint
	draw_ellipse_shadow(p+Vector2(16,29),Vector2(14,5))
	match type:
		"slime":
			draw_rect(Rect2(p+Vector2(3,17),Vector2(27,12)),color)
			draw_rect(Rect2(p+Vector2(8,11),Vector2(18,10)),color.lightened(0.1))
		"wolf":
			draw_rect(Rect2(p+Vector2(2,14),Vector2(22,12)),color)
			draw_rect(Rect2(p+Vector2(19,7),Vector2(12,13)),color)
			draw_rect(Rect2(p+Vector2(20,2),Vector2(4,7)),color)
		"bat":
			var flap := sin(animation*7)*3
			draw_colored_polygon(PackedVector2Array([p+Vector2(0,8+flap),p+Vector2(16,15),p+Vector2(31,8+flap),p+Vector2(25,24),p+Vector2(6,24)]),color)
			draw_rect(Rect2(p+Vector2(12,10),Vector2(9,18)),color.darkened(0.2))
		"guardian":
			draw_rect(Rect2(p+Vector2(-3,7),Vector2(38,25)),color.darkened(0.2))
			draw_rect(Rect2(p+Vector2(3,-9),Vector2(26,29)),color)
			draw_rect(Rect2(p+Vector2(8,4),Vector2(16,4)),Color("efd29c"))
	if type != "guardian":
		draw_rect(Rect2(p+Vector2(12,17),Vector2(3,4)),Color("203337"))
		draw_rect(Rect2(p+Vector2(22,17),Vector2(3,4)),Color("203337"))

func _building() -> void:
	var restored: bool = Game.state.flags.forge_repaired
	var p := Vector2(3*32, 2*32)
	draw_rect(Rect2(p+Vector2(4,31),Vector2(184,97)),Color("b5a17d") if restored else Color("7c7c6c"))
	draw_colored_polygon(PackedVector2Array([p+Vector2(-8,42),p+Vector2(96,-7),p+Vector2(200,42)]),Color("9e6551") if restored else Color("555f59"))
	draw_rect(Rect2(p+Vector2(79,77),Vector2(35,51)),Color("394248"))
	for x in [24,136]:
		draw_rect(Rect2(p+Vector2(x,62),Vector2(28,28)),Color("e7bd75") if restored else Color("46575a"))
	_label("HERRERÍA" if restored else "HERRERÍA ABANDONADA",p+Vector2(96,60),12,Color("eee0b9"),true)
