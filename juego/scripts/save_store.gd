class_name ValleySaveStore
extends RefCounted

const SLOT := "user://valley_slot_v1.json"
const Builds = preload("res://scripts/build_rules.gd")
const Regions = preload("res://scripts/regions.gd")
var last_error := ""
var migration_backup_failed := false

func write(state: Dictionary, path: String = SLOT) -> bool:
	last_error = ""
	if not valid(state):
		last_error = "No se guardó un estado inválido. La copia anterior permanece intacta."
		return false
	var text := JSON.stringify(state, "\t")
	var file := FileAccess.open(path + ".tmp", FileAccess.WRITE)
	if file == null:
		last_error = "No se pudo escribir la partida. Exporta una copia desde el menú."
		return false
	file.store_string(text)
	file.flush()
	file.close()
	if FileAccess.file_exists(path):
		# Never replace a good backup with a corrupt main slot.
		if valid(parse_text(FileAccess.get_file_as_string(path))):
			if DirAccess.copy_absolute(path, path + ".bak") != OK:
				last_error = "No se pudo conservar la copia anterior."
				return false
	if DirAccess.rename_absolute(path + ".tmp", path) != OK:
		last_error = "No se pudo finalizar el guardado."
		return false
	return true

func read(path: String = SLOT) -> Dictionary:
	last_error = ""
	migration_backup_failed = false
	for candidate in [path, path + ".bak"]:
		if not FileAccess.file_exists(candidate):
			continue
		var parsed: Variant = parse_text(FileAccess.get_file_as_string(candidate))
		if valid(parsed):
			if candidate != path:
				last_error = "Se recuperó la copia anterior: el archivo principal no era válido."
			if parsed.schema == 1:
				var original_path := path + ".before-schema2.json"
				if not FileAccess.file_exists(original_path) and DirAccess.copy_absolute(candidate, original_path) != OK:
					migration_backup_failed = true
					last_error += " No se pudo conservar la copia original antes de actualizar. El guardado automático está detenido; exporta una copia."
			return normalize(parsed)
	if FileAccess.file_exists(path) or FileAccess.file_exists(path + ".bak"):
		last_error = "No se pudo cargar la partida. Se conserva el archivo y el guardado automático está detenido."
	return {}

static func valid(value: Variant) -> bool:
	if not value is Dictionary:
		return false
	var d: Dictionary = value
	for key in ["schema", "region", "x", "y", "hp", "mp", "potions", "last_time", "resources", "flags", "workers", "production", "defeated", "battle"]:
		if not d.has(key):
			return false
	if (d.schema != 1 and d.schema != 2) or not d.region in ["village", "forest", "mine"]:
		return false
	for key in ["resources", "flags", "workers", "production", "battle"]:
		if not d[key] is Dictionary:
			return false
	if not d.defeated is Array or d.defeated.size() > 100:
		return false
	for id in d.defeated:
		if not id is String:
			return false
	for key in ["x", "y", "hp", "mp", "potions", "last_time"]:
		if not number(d[key]):
			return false
	for key in ["x", "y", "hp", "mp", "potions"]:
		if float(d[key]) != floor(float(d[key])):
			return false
	if d.x < 1 or d.x > 22 or d.y < 1 or d.y > 16 or d.hp < 0 or d.hp > 38 or d.mp < 0 or d.mp > 12 or d.potions < 0 or d.potions > 9999:
		return false
	for key in ["gold", "wood", "ore", "ingot"]:
		if not d.resources.has(key) or not number(d.resources[key]) or d.resources[key] < 0 or d.resources[key] > 1000000000:
			return false
		if float(d.resources[key]) != floor(float(d.resources[key])):
			return false
	for key in ["mine_open", "forge_repaired", "sword", "boss_defeated", "beacon"]:
		if not d.flags.has(key) or not d.flags[key] is bool:
			return false
	for key in ["mara", "ivo"]:
		if not d.workers.has(key) or not d.workers[key] is bool:
			return false
	for key in ["mine", "forge", "remainder"]:
		if not d.production.has(key) or not number(d.production[key]):
			return false
	if d.production.mine < 0 or d.production.mine >= 5 or d.production.forge < 0 or d.production.forge >= 8 or d.production.remainder < 0 or d.production.remainder >= 1:
		return false
	if not Regions.walkable(d.region, Vector2i(int(d.x), int(d.y)), d.defeated):
		return false
	if d.schema == 2 and not Builds.valid_loadouts(d):
		return false
	if not d.battle.is_empty():
		var b: Dictionary = d.battle
		for key in ["enemy", "instance", "hp", "turn", "status", "message"]:
			if not b.has(key):
				return false
		if not b.enemy in ["slime", "wolf", "bat", "guardian"] or not b.status in ["fighting", "won", "lost", "escaped"]:
			return false
		if not b.instance is String or not b.message is String or not number(b.hp) or not number(b.turn):
			return false
		if b.hp < 0 or b.hp > 64 or b.turn < 0 or b.turn > 100000:
			return false
		if d.schema == 2:
			for key in ["burn_turns", "focus"]:
				if not b.has(key) or not number(b[key]) or b[key] < 0 or b[key] > 6:
					return false
			if not b.get("practice") is bool:
				return false
			if b.practice:
				if not b.get("practice_return") is Dictionary:
					return false
				for key in ["hp", "mp", "potions"]:
					if not b.practice_return.has(key) or not number(b.practice_return[key]):
						return false
				if b.practice_return.hp <= 0 or b.practice_return.hp > 38 or b.practice_return.mp < 0 or b.practice_return.mp > 12 or b.practice_return.potions < 0 or b.practice_return.potions > 9999:
					return false
		if d.hp == 0 and b.status != "lost":
			return false
	elif d.hp <= 0:
		return false
	return true

static func number(v: Variant) -> bool:
	return (v is int or v is float) and is_finite(float(v))

static func parse_text(text: String) -> Variant:
	var json := JSON.new()
	if json.parse(text) != OK:
		return null
	return json.data

static func normalize(d: Dictionary) -> Dictionary:
	var result: Dictionary = d.duplicate(true)
	for key in ["schema", "x", "y", "hp", "mp", "potions"]:
		result[key] = int(result[key])
	for key in ["gold", "wood", "ore", "ingot"]:
		result.resources[key] = int(result.resources[key])
	for key in ["mine", "forge"]:
		result.production[key] = int(result.production[key])
	if not result.battle.is_empty():
		result.battle.hp = int(result.battle.hp)
		result.battle.turn = int(result.battle.turn)
	if int(result.schema) == 1:
		result.schema = 2
		result.active_style = "guardian"
		result.loadouts = Builds.defaults(result.flags.sword)
		if not result.battle.is_empty():
			result.battle.burn_turns = 0
			result.battle.focus = 0
			result.battle.practice = false
	return result
