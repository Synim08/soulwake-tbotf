extends RefCounted

const Combat = preload("res://combat_state.gd")
const SLOT := "user://prueba_combate_v1.json"
const MAX_BYTES := 8192
var slot := SLOT

func candidates() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for candidate in [slot, slot + ".bak"]:
		var data := _read(candidate)
		if not data.is_empty():
			result.append(data)
	return result

func _read(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null or file.get_length() > MAX_BYTES:
		return {}
	var parser := JSON.new()
	if parser.parse(file.get_as_text()) != OK:
		return {}
	var data: Variant = parser.data
	if not data is Dictionary or data.get("schema") != 1 or not data.get("combat") is Dictionary:
		return {}
	var validation = Combat.new()
	return data if validation.restore(data.combat, 2) else {}

func write(combat: Dictionary, broken_trunk: bool, damage_numbers: bool, charge_numbers: bool) -> bool:
	var payload := JSON.stringify({
		"schema": 1,
		"combat": combat,
		"broken_trunk": broken_trunk,
		"damage_numbers": damage_numbers,
		"charge_numbers": charge_numbers,
	})
	var file := FileAccess.open(slot + ".tmp", FileAccess.WRITE)
	if file == null:
		return false
	file.store_string(payload)
	file.flush()
	var error := file.get_error()
	file.close()
	if error != OK:
		return false
	if not _read(slot).is_empty():
		if DirAccess.copy_absolute(slot, slot + ".bak") != OK:
			return false
	return DirAccess.rename_absolute(slot + ".tmp", slot) == OK
