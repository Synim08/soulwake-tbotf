class_name ExpeditionSaveStore
extends RefCounted

const PATH := "user://valley_roguelite_slot_v1.json"
const Maps = preload("res://scripts/expedition_maps.gd")
const LIMIT := 1048576
const NODES := ["N0", "N1", "N2A", "N2B", "N3", "N4A", "N4B", "N5", "N6"]
const CLASSES := ["guardian", "assassin", "mage"]
const CLAIMS := ["chest", "river", "rest", "mara", "alijo", "R1", "R2", "W1", "E1"]
const ENEMIES := {"slime": 14, "wolf": 24, "bat": 18, "veteran": 36, "guardian": 64}
const NODE_ENEMY := {"N1": "slime", "N2B": "wolf", "N4A": "bat", "N4B": "veteran", "N6": "guardian"}
var last_error := ""

func path() -> String:
	return PATH

func write(state: Dictionary) -> bool:
	last_error = ""
	if not valid(state):
		last_error = "No se guardó un estado de expedición inválido. La copia anterior sigue intacta."
		return false
	var encoded := JSON.stringify(state, "\t")
	if encoded.to_utf8_buffer().size() > LIMIT:
		last_error = "La copia supera el tamaño permitido."
		return false
	var slot := path()
	var file := FileAccess.open(slot + ".tmp", FileAccess.WRITE)
	if file == null:
		last_error = "No se pudo escribir la expedición. Exporta una copia."
		return false
	file.store_string(encoded)
	file.flush()
	var error := file.get_error()
	file.close()
	if error != OK:
		last_error = "No se pudo completar la escritura de la expedición."
		return false
	# Never replace a valid backup with a damaged primary file.
	if FileAccess.file_exists(slot) and not _read_file(slot).is_empty():
		if DirAccess.copy_absolute(slot, slot + ".bak") != OK:
			last_error = "No se pudo conservar el respaldo anterior."
			return false
	if DirAccess.rename_absolute(slot + ".tmp", slot) != OK:
		last_error = "No se pudo finalizar el guardado de la expedición."
		return false
	return true

func read() -> Dictionary:
	last_error = ""
	var slot := path()
	for candidate in [slot, slot + ".bak"]:
		if not FileAccess.file_exists(candidate):
			continue
		var parsed := _read_file(candidate)
		if not parsed.is_empty():
			if candidate != slot:
				last_error = "Se recuperó el respaldo de la expedición; el archivo principal no era válido."
			return parsed
	if FileAccess.file_exists(slot) or FileAccess.file_exists(slot + ".bak"):
		last_error = "No se pudo cargar la expedición. Los archivos se conservaron; recupera una copia antes de guardar."
	return {}

static func _read_file(filename: String) -> Dictionary:
	var file := FileAccess.open(filename, FileAccess.READ)
	if file == null or file.get_length() > LIMIT:
		return {}
	return parse_text(file.get_as_text())

static func parse_text(text: String) -> Dictionary:
	if text.to_utf8_buffer().size() > LIMIT:
		return {}
	var json := JSON.new()
	if json.parse(text) != OK or not valid(json.data):
		return {}
	var normalized: Dictionary = json.data
	for key in ["schema", "sequence"]:
		normalized[key] = int(normalized[key])
	for key in ["wood", "ore"]:
		normalized.campaign[key] = int(normalized.campaign[key])
	if not normalized.last_result.is_empty():
		for key in ["wood", "ore", "lost_wood", "lost_ore"]:
			normalized.last_result[key] = int(normalized.last_result[key])
	if not normalized.active_run.is_empty():
		var run: Dictionary = normalized.active_run
		if run.has("variation"):
			for node in run.variation.encounters: run.variation.encounters[node] = int(run.variation.encounters[node])
		if not run.battle.is_empty() and run.battle.has("variant"): run.battle.variant = int(run.battle.variant)
		for key in ["seed", "x", "y", "hp", "mp", "potions", "potion_heal", "max_mp"]:
			run[key] = int(run[key])
		for key in ["wood", "ore"]:
			run.bag[key] = int(run.bag[key])
		if not run.battle.is_empty():
			for key in ["hp", "max_hp", "turn", "phase", "phase_turn", "burn_turns", "focus"]:
				run.battle[key] = int(run.battle[key])
	return normalized

static func integer(value: Variant, minimum: int = 0, maximum: int = 999999) -> bool:
	return (value is int or value is float) and is_finite(float(value)) and float(value) == floor(float(value)) and value >= minimum and value <= maximum

static func fields(value: Variant, required: Array) -> bool:
	if not value is Dictionary:
		return false
	for key in required:
		if not value.has(key):
			return false
	return true

static func tokens(value: Variant, allowed: Array, maximum: int) -> bool:
	if not value is Array or value.size() > maximum:
		return false
	var seen := {}
	for item in value:
		if not item is String or not item in allowed or seen.has(item):
			return false
		seen[item] = true
	return true

static func upgrades_for(style: String) -> Array:
	var prefix := "G" if style == "guardian" else ("A" if style == "assassin" else "M")
	return [prefix + "01", prefix + "02", prefix + "03", "C01", "C02", "C03"]

static func valid(value: Variant) -> bool:
	if not fields(value, ["schema", "mode", "campaign", "active_run", "last_result", "sequence"]):
		return false
	if value.schema != 1 or value.mode != "roguelite" or not integer(value.sequence, 0, 2147483647):
		return false
	var c: Variant = value.campaign
	if not fields(c, ["wood", "ore", "patio", "mara", "boss", "botica", "arsenal", "class", "kit", "weapon"]):
		return false
	if not integer(c.wood) or not integer(c.ore) or not c["class"] in CLASSES or not c.kit in ["normal", "small"] or not c.weapon in ["basic", "tactical"]:
		return false
	for key in ["patio", "mara", "boss", "botica", "arsenal"]:
		if not c[key] is bool:
			return false
	if (c.botica and not c.mara) or (c.arsenal and not c.boss) or (c.kit == "small" and not c.botica) or (c.weapon == "tactical" and not c.arsenal):
		return false
	if not value.active_run is Dictionary or not value.last_result is Dictionary:
		return false
	var result: Dictionary = value.last_result
	if not result.is_empty():
		if not fields(result, ["id", "outcome", "wood", "ore", "lost_wood", "lost_ore", "mara", "boss", "ack"]):
			return false
		if not result.id is String or result.id.is_empty() or result.id.length() > 128 or not result.outcome in ["won", "lost", "retired"]:
			return false
		for key in ["wood", "ore", "lost_wood", "lost_ore"]:
			if not integer(result[key]):
				return false
		for key in ["mara", "boss", "ack"]:
			if not result[key] is bool:
				return false
		if result.outcome == "lost" and (result.wood != 0 or result.ore != 0 or result.mara or result.boss):
			return false
		if result.outcome != "lost" and (result.lost_wood != 0 or result.lost_ore != 0):
			return false
	var r: Dictionary = value.active_run
	if r.is_empty():
		return true
	if not c.patio or (not result.is_empty() and not result.ack):
		return false
	if not fields(r, ["id", "seed", "node", "x", "y", "class", "kit", "weapon", "hp", "mp", "potions", "potion_heal", "max_mp", "bag", "upgrades", "visited", "cleared", "claimed", "offers", "pending_offer", "battle", "mara_contact"]):
		return false
	if not r.id is String or r.id.is_empty() or r.id.length() > 128 or not integer(r.seed, 0, 2147483647):
		return false
	if not r.node in NODES or not r["class"] in CLASSES or not r.kit in ["normal", "small"] or not r.weapon in ["basic", "power", "tactical"]:
		return false
	if not integer(r.x, 1, 16) or not integer(r.y, 1, 10) or not integer(r.hp, 1, 38) or not integer(r.mp, 0, 15) or not integer(r.potions, 0, 3):
		return false
	if not Maps.walkable(r.node, Vector2i(int(r.x), int(r.y))):
		return false
	if not integer(r.potion_heal, 12, 22) or not int(r.potion_heal) in [12, 22] or not integer(r.max_mp, 12, 15) or not int(r.max_mp) in [12, 15] or r.mp > r.max_mp:
		return false
	if not fields(r.bag, ["wood", "ore"]) or not integer(r.bag.wood) or not integer(r.bag.ore):
		return false
	var compatible := upgrades_for(r["class"])
	if not tokens(r.upgrades, compatible, 6) or not tokens(r.visited, NODES, 7) or not tokens(r.cleared, NODES, 7) or not tokens(r.claimed, CLAIMS, 9):
		return false
	if not r.node in r.visited or r.max_mp != (15 if "C03" in r.upgrades else 12):
		return false
	for node in r.cleared:
		if not node in r.visited:
			return false
	if not r.mara_contact is bool or not r.pending_offer in ["", "R1", "R2", "W1", "E1"] or not r.offers is Dictionary or r.offers.size() > 4:
		return false
	for key in r.offers:
		if not key in ["R1", "R2", "W1", "E1"] or not tokens(r.offers[key], ["power", "tactical"] if key == "W1" else compatible, 3):
			return false
	if not r.pending_offer.is_empty() and (not r.offers.has(r.pending_offer) or r.offers[r.pending_offer].is_empty() or r.pending_offer in r.claimed):
		return false
	if r.has("variation"):
		if not fields(r.variation,["encounters","event"]) or not r.variation.event in ["merchant","altar","traveler"] or not r.variation.encounters is Dictionary: return false
		if r.variation.encounters.size() != 4: return false
		for node in ["N1","N2B","N4A","N4B"]:
			if not r.variation.encounters.has(node) or not integer(r.variation.encounters[node],0,1): return false
		if not r.get("event_claimed") is bool or not r.get("traveler") is bool: return false
	elif r.has("event_claimed") or r.has("traveler"): return false
	if not r.battle is Dictionary:
		return false
	if not r.battle.is_empty() and not valid_battle(r):
		return false
	return true

static func valid_battle(r: Dictionary) -> bool:
	var b: Dictionary = r.battle
	if not fields(b, ["enemy", "hp", "max_hp", "turn", "phase", "phase_turn", "guard", "burn_turns", "focus", "prepared", "message"]):
		return false
	if not b.enemy in ENEMIES or NODE_ENEMY.get(r.node, "") != b.enemy or r.node in r.cleared or not r.pending_offer.is_empty():
		return false
	if not integer(b.max_hp, 1, 64) or b.max_hp != ENEMIES[b.enemy] or not integer(b.hp, 1, int(b.max_hp)):
		return false
	if not integer(b.turn, 0, 100000) or not integer(b.phase, 0, 1) or not integer(b.phase_turn, 0, 100000) or not integer(b.burn_turns, 0, 8) or not integer(b.focus, 0, 3):
		return false
	if b.has("variant") and (not integer(b.variant,0,1) or int(b.variant) != int(r.get("variation",{}).get("encounters",{}).get(r.node,0))): return false
	return b.guard is bool and b.prepared is bool and b.message is String and b.message.length() <= 4096
