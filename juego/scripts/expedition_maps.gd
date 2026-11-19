class_name ExpeditionMaps
extends RefCounted

const Rules = preload("res://scripts/expedition_rules.gd")
const SIZE := Vector2i(18, 12)
const TITLES := {"village":"Refugio del Alba", "N0":"Entrada del sendero", "N1":"Claro de savia", "N2A":"Ribera de hierbas", "N2B":"Linde del lobo", "N3":"Campamento abandonado", "N4A":"Ruinas forestales", "N4B":"Claro de tala", "N5":"Umbral de raíces", "N6":"Guardián del Sendero"}

static func obstacles(node: String) -> Array:
	var out: Array = []
	match node:
		"village":
			for x in range(4, 8):
				for y in range(2, 4): out.append(Vector2i(x,y))
			for x in range(11, 15):
				for y in range(2, 4): out.append(Vector2i(x,y))
		"N2A":
			for x in range(7, 14):
				for y in range(8, 11): out.append(Vector2i(x,y))
		"N4A":
			for p in [Vector2i(6,3),Vector2i(7,3),Vector2i(8,3),Vector2i(6,4),Vector2i(6,8),Vector2i(7,8)]: out.append(p)
		"N4B":
			for p in [Vector2i(5,3),Vector2i(6,3),Vector2i(5,9),Vector2i(11,9)]: out.append(p)
		_:
			for p in [Vector2i(5,2),Vector2i(6,2),Vector2i(7,9),Vector2i(8,9),Vector2i(13,3)]: out.append(p)
	return out

static func walkable(node: String, p: Vector2i) -> bool:
	return p.x > 0 and p.y > 0 and p.x < 17 and p.y < 11 and not obstacles(node).has(p)

static func objects(state: Dictionary) -> Array:
	var run: Dictionary = state.active_run
	if run.is_empty():
		return [{"id":"prepare","name":"Patio de aventureros","at":Vector2i(6,4),"kind":"building"}, {"id":"projects","name":"Proyectos del pueblo","at":Vector2i(12,4),"kind":"building"}, {"id":"depart","name":"Salir al bosque","at":Vector2i(15,6),"kind":"exit"}]
	var items: Array = []
	var node: String = run.node
	var clear: bool = run.cleared.has(node)
	if node in ["N1","N2B","N4A","N4B","N6"] and not clear:
		items.append({"id":"enemy","name":Rules.encounter_name(run,node),"at":Vector2i(10,6),"kind":"enemy"})
	if node == "N1" and not run.claimed.has("chest"):
		items.append({"id":"chest","name":"Cofre del desvío","at":Vector2i(4,3),"kind":"chest"})
	if node == "N2A" and not run.claimed.has("river"): items.append({"id":"herbs","name":"Hierbas de ribera","at":Vector2i(10,7),"kind":"herbs"})
	if node == "N3" and not run.claimed.has("rest"): items.append({"id":"fire","name":"Fuego de campamento","at":Vector2i(9,5),"kind":"fire"})
	if node == "N4A" and clear: items.append({"id":"mara","name":"Mensaje de Mara" if state.campaign.mara else "Mara, refugiada","at":Vector2i(13,4),"kind":"person"})
	if node == "N5" and not run.claimed.has("alijo"): items.append({"id":"alijo","name":"Alijo de provisiones","at":Vector2i(9,5),"kind":"chest"})
	if node == "N3" and run.has("variation") and not run.event_claimed:
		items.append({"id":"encounter_event","name":Rules.event_name(run),"at":Vector2i(12,4),"kind":"person"})
	if node != "N6": items.append({"id":"exit","name":"Siguiente sendero","at":Vector2i(15,6),"kind":"exit"})
	return items
