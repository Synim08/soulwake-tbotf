class_name ValleyRegions
extends RefCounted

const SIZE := Vector2i(24, 17)
const NAMES := {"village": "Refugio del Alba", "forest": "Bosque del sendero", "mine": "La veta antigua"}

static func objects(region: String) -> Array:
	match region:
		"village":
			return [
				{"id": "forge", "label": "Herrería", "at": Vector2i(6, 6), "kind": "forge"},
				{"id": "elder", "label": "Alba · guardiana", "at": Vector2i(11, 6), "kind": "person"},
				{"id": "mara", "label": "Mara · minera", "at": Vector2i(8, 10), "kind": "person"},
				{"id": "ivo", "label": "Ivo · herrero", "at": Vector2i(5, 8), "kind": "person"},
				{"id": "rest", "label": "Fuego · descansar", "at": Vector2i(12, 10), "kind": "fire"},
				{"id": "beacon", "label": "Faro del valle", "at": Vector2i(18, 5), "kind": "beacon"},
				{"id": "supplies", "label": "Pociones · 6 monedas", "at": Vector2i(16, 11), "kind": "crate"},
				{"id": "to_forest", "label": "Bosque >", "at": Vector2i(22, 8), "kind": "portal", "to": "forest", "spawn": Vector2i(2, 8)}]
		"forest":
			return [
				{"id": "to_village", "label": "< Pueblo", "at": Vector2i(1, 8), "kind": "portal", "to": "village", "spawn": Vector2i(21, 8)},
				{"id": "forest_slime_1", "label": "Slime", "at": Vector2i(7, 8), "kind": "enemy", "enemy": "slime"},
				{"id": "forest_slime_2", "label": "Slime", "at": Vector2i(12, 6), "kind": "enemy", "enemy": "slime"},
				{"id": "forest_wolf", "label": "Lobo del sendero", "at": Vector2i(18, 8), "kind": "enemy", "enemy": "wolf"},
				{"id": "to_mine", "label": "Mina >", "at": Vector2i(22, 8), "kind": "portal", "to": "mine", "spawn": Vector2i(2, 8)}]
		"mine":
			return [
				{"id": "to_forest", "label": "< Bosque", "at": Vector2i(1, 8), "kind": "portal", "to": "forest", "spawn": Vector2i(21, 8)},
				{"id": "mine_bat_1", "label": "Murciélago", "at": Vector2i(8, 9), "kind": "enemy", "enemy": "bat"},
				{"id": "mine_bat_2", "label": "Murciélago", "at": Vector2i(13, 6), "kind": "enemy", "enemy": "bat"},
				{"id": "ore", "label": "Veta · recoger mineral", "at": Vector2i(6, 5), "kind": "ore"},
				{"id": "mine_guardian", "label": "Guardián de la veta", "at": Vector2i(19, 8), "kind": "enemy", "enemy": "guardian"}]
	return []

static func tile(region: String, point: Vector2i) -> int:
	var x := point.x
	var y := point.y
	if x <= 0 or y <= 0 or x >= SIZE.x - 1 or y >= SIZE.y - 1:
		return 6 if region == "mine" else 0
	if region == "mine":
		if (y < 3 or y > 13) and x > 3:
			return 6
		if (x == 11 and y >= 10 and y <= 12) or (x >= 15 and x <= 17 and y == 4):
			return 6
		return 4 if y < 7 or y > 9 else 3
	if region == "village":
		if x >= 2 and x <= 5 and y >= 11 and y <= 14:
			return 2
		if y >= 7 and y <= 9 or x >= 10 and x <= 12 and y >= 5 or y == 6 and x >= 5 and x <= 18:
			return 1
	else:
		if y >= 7 and y <= 9 or y == 6 and x >= 9 and x <= 14:
			return 1
		if x >= 14 and x <= 16 and y >= 11 and y <= 14:
			return 2
	return 5 if (x * 7 + y * 13) % 11 == 0 else 0

static func trees(region: String) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	if region == "mine":
		return result
	for y in range(1, 16):
		for x in range(1, 23):
			if y >= 6 and y <= 10:
				continue
			if region == "village" and x >= 3 and x <= 20 and y <= 12:
				continue
			if tile(region, Vector2i(x, y)) in [0, 5] and (x * 13 + y * 7) % (4 if region == "forest" else 7) == 0:
				result.append(Vector2i(x, y))
	return result

static func walkable(region: String, point: Vector2i, defeated: Array) -> bool:
	if point.x <= 0 or point.y <= 0 or point.x >= SIZE.x - 1 or point.y >= SIZE.y - 1:
		return false
	if tile(region, point) in [2, 6] or trees(region).has(point):
		return false
	if region == "village" and Rect2i(3, 2, 6, 4).has_point(point):
		return false
	for obj in objects(region):
		if obj.at == point and obj.kind != "portal" and not (obj.kind == "enemy" and defeated.has(obj.id)):
			return false
	return true
