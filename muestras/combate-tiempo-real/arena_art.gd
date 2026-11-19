extends Node2D
## Escenario de 288 × 156 píxeles lógicos, ampliado cuatro veces.
## La decoración no modifica el área caminable ni las colisiones de la arena.

const INK := Color("#101e21")
const SHADE := Color("#192d2a")
const GRASS_DARK := Color("#294137")
const GRASS := Color("#364e3c")
const GRASS_LIT := Color("#405743")
const GRASS_TIP := Color("#617451")
const DIRT_DARK := Color("#63583d")
const DIRT := Color("#78684a")
const DIRT_LIT := Color("#8d7954")
const WOOD_DARK := Color("#322e2a")
const WOOD := Color("#534537")
const WOOD_LIT := Color("#786247")
const CANOPY_DARK := Color("#203731")
const CANOPY := Color("#2d4938")
const CANOPY_LIT := Color("#425e40")
const LEAF_LIGHT := Color("#58734a")
const STONE_DARK := Color("#364b43")
const STONE := Color("#536358")
const STONE_LIT := Color("#718070")
const TEAL := Color("#77b5a0")
const DULL_TEAL := Color("#456e62")

var _rng := RandomNumberGenerator.new()


func _draw() -> void:
	_rng.seed = 48119
	draw_set_transform(Vector2.ZERO, 0, Vector2(4, 4))
	_ground()
	_scatter_ground_details()
	_forest_border()
	_entry_markers()
	draw_set_transform(Vector2.ZERO)


func _pixel_rect(x: int, y: int, width: int, height: int, tint: Color) -> void:
	draw_rect(Rect2(x, y, width, height), tint)


func _ellipse(x: int, y: int, rx: int, ry: int, tint: Color, step: int = 1) -> void:
	for row in range(-ry, ry + 1, step):
		var depth := float(row) / ry
		var half_width := maxi(1, floori(rx * sqrt(1.0 - depth * depth)))
		_pixel_rect(x - half_width, y + row, 2 * half_width + 1, step, tint)


func _terrain_noise(x: int, y: int) -> float:
	return sin(x * 0.13 + cos(y * 0.21) * 0.9) + cos(y * 0.22 - x * 0.08)


func _trail_center(x: int) -> float:
	return 103.0 - x * 0.16 + sin(x * 0.036) * 6.0


func _ground() -> void:
	_pixel_rect(0, 0, 288, 156, GRASS_DARK)
	# Contornos irregulares con bandas de píxeles continuas.
	var terrain: Array[Color] = [GRASS_DARK, GRASS, GRASS_LIT, DIRT_DARK, DIRT, DIRT_LIT]
	for y in range(156):
		var run_start := 0
		var previous := -1
		for x in range(289):
			var terrain_index := -1
			if x < 288:
				var noise := _terrain_noise(x, y)
				var lit := Vector2((x - 158) / 143.0, (y - 81) / 61.0).length()
				var trail_distance := absf(y - _trail_center(x))
				var trail_radius := 8.0 + sin(x * 0.073) * 2.2 + noise * 1.2
				terrain_index = 0 if lit > 0.93 + noise * 0.055 else 1
				if lit < 0.63 + noise * 0.075:
					terrain_index = 2
				if trail_distance < trail_radius + 2.0:
					terrain_index = 3
				if trail_distance < trail_radius:
					terrain_index = 5 if noise > 0.85 else 4
			if terrain_index != previous:
				if previous >= 0:
					_pixel_rect(run_start, y, x - run_start, 1, terrain[previous])
				run_start = x
				previous = terrain_index
	# Entrada de tierra entre las copas y un poco de desgaste en el borde interior.
	_pixel_rect(0, 97, 21, 12, DIRT)
	_pixel_rect(0, 109, 17, 2, DIRT_DARK)


func _scatter_ground_details() -> void:
	for n in range(330):
		var x := _rng.randi_range(8, 280)
		var y := _rng.randi_range(16, 147)
		var near_trail := absf(y - _trail_center(x)) < 9
		if near_trail:
			var pebble := DIRT_DARK if n % 3 == 0 else DIRT_LIT
			_pixel_rect(x, y, _rng.randi_range(1, 3), 1, pebble)
		else:
			var grass_color := GRASS_TIP if n % 5 == 0 else GRASS_DARK
			_pixel_rect(x, y, _rng.randi_range(1, 3), 1, grass_color)
			if n % 4 == 0:
				_pixel_rect(x + 1, y - 1, 1, 2, grass_color)

	for p: Vector2i in [
		Vector2i(37, 67), Vector2i(42, 136), Vector2i(75, 119),
		Vector2i(113, 45), Vector2i(116, 131), Vector2i(166, 121),
		Vector2i(209, 35), Vector2i(224, 124), Vector2i(246, 53),
		Vector2i(262, 98)
	]:
		_grass_tuft(p.x, p.y, p.x % 2 == 0)

	for p: Vector2i in [
		Vector2i(30, 125), Vector2i(62, 83), Vector2i(85, 111),
		Vector2i(132, 103), Vector2i(187, 48), Vector2i(200, 110),
		Vector2i(232, 91), Vector2i(248, 135), Vector2i(255, 77)
	]:
		_pebbles(p.x, p.y)


func _grass_tuft(x: int, y: int, flowering: bool) -> void:
	_pixel_rect(x - 4, y + 3, 9, 1, GRASS_DARK)
	_pixel_rect(x - 3, y, 1, 3, GRASS_TIP)
	_pixel_rect(x, y - 2, 1, 5, GRASS_TIP)
	_pixel_rect(x + 2, y + 1, 2, 2, GRASS_TIP)
	_pixel_rect(x + 3, y, 1, 2, GRASS_LIT)
	if flowering:
		_pixel_rect(x - 1, y - 3, 3, 1, Color("#a59963"))
		_pixel_rect(x, y - 4, 1, 3, Color("#c2af77"))


func _pebbles(x: int, y: int) -> void:
	_pixel_rect(x - 2, y + 2, 7, 1, GRASS_DARK)
	_pixel_rect(x, y, 3, 3, STONE)
	_pixel_rect(x + 1, y - 1, 2, 1, STONE_LIT)
	_pixel_rect(x + 5, y + 2, 2, 1, STONE)
	_pixel_rect(x - 3, y + 1, 1, 1, STONE_LIT)


func _forest_border() -> void:
	_pixel_rect(0, 0, 288, 10, INK)
	_pixel_rect(0, 147, 288, 9, SHADE)
	for patch: Vector2i in [
		Vector2i(0, 14), Vector2i(18, 14), Vector2i(47, 10), Vector2i(74, 11),
		Vector2i(92, 16), Vector2i(122, 12), Vector2i(151, 13), Vector2i(174, 15),
		Vector2i(202, 13), Vector2i(227, 11), Vector2i(255, 16), Vector2i(280, 14)
	]:
		_ellipse(patch.x, patch.y, 17, 9, SHADE, 2)

	for tree: Vector3i in [
		Vector3i(6, 27, 21), Vector3i(32, 16, 14), Vector3i(55, 22, 18),
		Vector3i(83, 15, 15), Vector3i(101, 18, 13), Vector3i(123, 16, 18),
		Vector3i(146, 13, 14), Vector3i(163, 19, 16), Vector3i(191, 15, 18),
		Vector3i(215, 16, 15), Vector3i(239, 17, 17), Vector3i(266, 22, 19),
		Vector3i(286, 30, 19),
		Vector3i(2, 57, 17), Vector3i(3, 88, 14), Vector3i(284, 56, 16),
		Vector3i(288, 94, 19), Vector3i(286, 127, 14), Vector3i(3, 145, 20),
		Vector3i(37, 162, 18), Vector3i(67, 167, 16), Vector3i(95, 161, 13),
		Vector3i(119, 169, 14), Vector3i(145, 163, 13), Vector3i(174, 168, 14),
		Vector3i(200, 165, 16), Vector3i(229, 161, 13), Vector3i(251, 168, 15),
		Vector3i(278, 158, 18)
	]:
		_tree(tree.x, tree.y, tree.z)

	_fern(15, 74)
	_fern(18, 124)
	_fern(267, 112)
	_fern(270, 46)
	_fern(73, 141)
	_fern(218, 143)
	_waystone(103, 19)
	_waystone(255, 21)


func _tree(x: int, base_y: int, radius: int) -> void:
	var crown_y := base_y - roundi(radius * 0.85)
	var half := floori(radius * 0.5)
	var third := floori(radius / 3.0)
	var quarter := floori(radius * 0.25)
	_ellipse(x + 3, base_y - 1, radius, 4, SHADE)
	_pixel_rect(x - 3, base_y - 13, 7, 13, WOOD_DARK)
	_pixel_rect(x - 2, base_y - 11, 5, 10, WOOD)
	_pixel_rect(x - 1, base_y - 10, 1, 8, WOOD_LIT)
	_pixel_rect(x - 6, base_y - 2, 5, 2, WOOD_DARK)
	_pixel_rect(x + 2, base_y - 2, 7, 2, WOOD_DARK)
	_pixel_rect(x + 5, base_y - 1, 4, 1, WOOD)
	_ellipse(x + 1, crown_y + 2, radius, maxi(6, half), INK, 2)
	_ellipse(x, crown_y, radius - 1, maxi(6, half), CANOPY_DARK, 2)
	_ellipse(x - third, crown_y - 3, maxi(5, floori(radius * 2.0 / 3.0)), maxi(4, third), CANOPY, 2)
	_ellipse(x + third, crown_y - 1, maxi(5, half), maxi(4, third), CANOPY, 2)
	_ellipse(x - 1, crown_y - 6, maxi(4, half), maxi(3, quarter), CANOPY_LIT, 2)
	for n in range(12):
		var lx := x + _rng.randi_range(-radius + 3, radius - 3)
		var ly := crown_y + _rng.randi_range(-maxi(3, third), maxi(2, quarter))
		var color := LEAF_LIGHT if n % 5 == 0 and ly < crown_y else CANOPY_LIT
		_pixel_rect(lx, ly, _rng.randi_range(2, 4), 1, color)
		if n % 2 == 0:
			_pixel_rect(lx + 1, ly + 1, 2, 1, color)


func _fern(x: int, y: int) -> void:
	_ellipse(x, y + 2, 5, 2, SHADE)
	_pixel_rect(x, y - 5, 1, 8, GRASS_TIP)
	_pixel_rect(x - 5, y - 4, 4, 1, CANOPY_LIT)
	_pixel_rect(x - 4, y - 3, 3, 1, GRASS_TIP)
	_pixel_rect(x - 2, y - 2, 2, 1, GRASS_TIP)
	_pixel_rect(x + 1, y - 3, 3, 1, GRASS_TIP)
	_pixel_rect(x + 3, y - 4, 3, 1, CANOPY_LIT)
	_pixel_rect(x + 1, y, 4, 1, CANOPY_LIT)
	_pixel_rect(x - 4, y, 4, 1, CANOPY_LIT)


func _waystone(x: int, y: int) -> void:
	_ellipse(x, y + 1, 7, 2, SHADE)
	_pixel_rect(x - 5, y - 2, 10, 3, STONE_DARK)
	_pixel_rect(x - 3, y - 12, 7, 11, STONE_DARK)
	_pixel_rect(x - 2, y - 11, 5, 9, STONE)
	_pixel_rect(x - 2, y - 13, 5, 2, STONE_LIT)
	_pixel_rect(x, y - 10, 1, 5, DULL_TEAL)
	_pixel_rect(x - 1, y - 8, 3, 1, TEAL)
	_pixel_rect(x, y - 9, 1, 3, TEAL)


func _entry_markers() -> void:
	# Dos postes bajos enmarcan el sendero en el límite, sin tapar la entrada.
	for y in [95, 111]:
		_pixel_rect(2, y + 3, 8, 2, DIRT_DARK)
		_pixel_rect(3, y - 5, 5, 9, WOOD_DARK)
		_pixel_rect(4, y - 5, 3, 7, WOOD)
		_pixel_rect(3, y - 6, 5, 2, WOOD_LIT)
		_pixel_rect(4, y - 2, 3, 1, TEAL)
