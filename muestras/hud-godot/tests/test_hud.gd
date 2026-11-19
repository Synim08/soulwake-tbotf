extends SceneTree
## UI-only checks. No autoloads, campaign state, persistence, or user:// writes.

var checks := 0
var failures: Array[String] = []
var hud

func _initialize() -> void:
	call_deferred("run")

func check(condition: bool, description: String) -> void:
	checks += 1
	if not condition:
		failures.append(description)
		push_error("HUD: " + description)

func settle() -> void:
	await process_frame
	await process_frame

func fits(inner: Rect2, outer: Rect2, tolerance: float = 2.0) -> bool:
	return outer.grow(tolerance).encloses(inner)

func press_key(code: Key) -> void:
	var event := InputEventKey.new()
	event.physical_keycode = code
	event.keycode = code
	event.pressed = true
	Input.parse_input_event(event)
	await process_frame
	event = InputEventKey.new()
	event.physical_keycode = code
	event.keycode = code
	event.pressed = false
	Input.parse_input_event(event)
	await process_frame

func value_text(path: NodePath) -> String:
	return str(hud.get_node(path).text).replace(" ", "")

func run() -> void:
	var packed = load("res://hud/compact_hud.tscn")
	if not packed is PackedScene:
		check(false, "Reusable HUD scene loads")
		finish()
		return
	hud = packed.instantiate()
	root.add_child(hud)
	await settle()
	var required := ["Hero/Health", "Hero/Mana", "Hero/HealthValue", "Hero/ManaValue", "Hero/LowHealth", "Hero/Potion", "Objective/Text", "Objective/Progress", "Status/Hostile", "Status/Retreat", "Bag", "BagPopup", "BagPopup/Materials", "Navigation/Map", "Navigation/Menu"]
	var missing: Array[String] = []
	for path in required:
		if not hud.has_node(path):
			missing.append(path)
	check(missing.is_empty(), "Stable UI nodes exist: " + ", ".join(missing))
	if not missing.is_empty():
		finish()
		return

	var life: ProgressBar = hud.get_node("Hero/Health")
	var mana: ProgressBar = hud.get_node("Hero/Mana")
	hud.set_state({"hp": 14, "max_hp": 38, "mp": 12, "max_mp": 22, "potions": 2, "bag_used": 6, "bag_capacity": 12, "objective": "Investiga la resonancia", "progress": "1/3", "hostile": true, "retreat_available": true})
	await settle()
	check(life.value == 14 and life.max_value == 38 and is_equal_approx(life.value / life.max_value, 14.0 / 38.0), "Health bar represents 14/38 proportionally")
	check(mana.value == 12 and mana.max_value == 22 and value_text("Hero/HealthValue") == "14/38" and value_text("Hero/ManaValue") == "12/22", "Meters and numerical labels agree")
	check(hud.get_node("Hero/LowHealth").is_visible_in_tree(), "Low health has a visible text warning")
	var previous: Dictionary = hud.state.duplicate(true)
	hud.set_state({"hp": 38})
	check(hud.state.mp == previous.mp and hud.state.potions == previous.potions and hud.state.objective == previous.objective, "Partial updates preserve unrelated state")
	check(life.value == 38 and not hud.get_node("Hero/LowHealth").visible, "Full health removes low-health warning")

	hud.set_state({"hp": -10, "max_hp": 0, "mp": 100, "max_mp": -5, "potions": -2, "bag_used": -8, "bag_capacity": 0})
	check(is_finite(life.value) and is_finite(mana.value) and life.value >= life.min_value and life.value <= life.max_value and mana.value >= mana.min_value and mana.value <= mana.max_value, "Invalid maxima and values leave safe finite meter ranges")
	var labels := (value_text("Hero/HealthValue") + value_text("Hero/ManaValue")).to_lower()
	check(not labels.contains("nan") and not labels.contains("inf"), "Zero/negative maxima do not produce invalid numerical labels")
	check(int(hud.state.hp) >= 0 and int(hud.state.mp) >= 0 and int(hud.state.potions) >= 0 and int(hud.state.bag_used) >= 0 and int(hud.state.bag_capacity) >= 0, "Negative quantities are normalized safely")

	hud.set_state({"hp": 14, "max_hp": 38, "mp": 12, "max_mp": 22, "potions": 2, "bag_used": 12, "bag_capacity": 12, "hostile": false, "retreat_available": false})
	check(not hud.get_node("Status/Hostile").visible and str(hud.get_node("Status/Retreat").text).to_lower().contains("bloqueada"), "Hostility visibility and blocked-retreat text follow state")
	hud.set_state({"hostile": true, "retreat_available": true})
	check(hud.get_node("Status/Hostile").visible and str(hud.get_node("Status/Retreat").text).to_lower().contains("disponible"), "Available retreat is explicitly restored")

	var calls := {"map": 0, "menu": 0, "potion": 0}
	var bag_events: Array[bool] = []
	hud.map_requested.connect(func(): calls["map"] += 1)
	hud.menu_requested.connect(func(): calls["menu"] += 1)
	hud.potion_requested.connect(func(): calls["potion"] += 1)
	hud.bag_toggled.connect(func(open: bool): bag_events.append(open))
	hud.get_node("Navigation/Map").pressed.emit()
	hud.get_node("Navigation/Menu").pressed.emit()
	hud.get_node("Hero/Potion").pressed.emit()
	check(calls == {"map": 1, "menu": 1, "potion": 1}, "Action buttons emit requests without owning gameplay")
	var state_before_request: Dictionary = hud.state.duplicate(true)
	await press_key(KEY_M)
	await press_key(KEY_Q)
	check(calls["map"] == 2 and calls["potion"] == 2 and hud.state == state_before_request, "Keyboard requests preserve demonstration data")
	hud.get_node("Bag").pressed.emit()
	await settle()
	check(hud.get_node("BagPopup").visible and hud.get_node("Bag").button_pressed, "Bag control opens its detail and selected state")
	var menu_before: int = calls["menu"]
	await press_key(KEY_ESCAPE)
	check(not hud.get_node("BagPopup").visible and calls["menu"] == menu_before and bag_events == [true, false], "Escape closes bag once without also requesting menu")
	await press_key(KEY_ESCAPE)
	check(calls["menu"] == menu_before + 1, "Escape requests menu when no popup is open")
	var input := LineEdit.new()
	input.size = Vector2(160, 32)
	root.add_child(input)
	input.grab_focus()
	await settle()
	var counts_before_edit: Dictionary = calls.duplicate()
	await press_key(KEY_M)
	await press_key(KEY_Q)
	check(calls == counts_before_edit, "Typing in a focused text field does not trigger HUD shortcuts")
	input.queue_free()
	await process_frame

	# Use a long translated objective to catch minimum-size growth and overlaps.
	hud.set_state({"objective": "Investiga la resonancia entre las raíces del antiguo faro y encuentra el fragmento que guarda el sendero", "progress": "12/120", "materials": [{"name": "Madera", "amount": 4}, {"name": "Mineral", "amount": 2}, {"name": "Cristal", "amount": 1}]})
	var objective_label: Label = hud.get_node("Objective/Text")
	check(objective_label.autowrap_mode != TextServer.AUTOWRAP_OFF or objective_label.clip_text or objective_label.text_overrun_behavior != TextServer.OVERRUN_NO_TRIMMING, "Long objectives wrap or trim instead of overflowing horizontally")
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_DISABLED
	root.content_scale_size = Vector2i.ZERO
	for resolution in [Vector2i(1600, 900), Vector2i(1280, 720), Vector2i(960, 540)]:
		root.size = resolution
		hud.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
		hud.position = Vector2.ZERO
		hud.size = Vector2(resolution)
		await settle()
		var bounds: Rect2 = hud.get_global_rect()
		var paths := ["Hero", "Objective", "Status", "Bag", "Navigation"]
		var panels: Array[Rect2] = []
		var layout_ok := true
		for path in paths:
			var panel: Control = hud.get_node(path)
			var area := panel.get_global_rect()
			layout_ok = layout_ok and fits(area, bounds)
			panels.append(area)
		for i in panels.size():
			for j in range(i + 1, panels.size()):
				layout_ok = layout_ok and not panels[i].grow(-1.0).intersects(panels[j].grow(-1.0))
		var navigation: Control = hud.get_node("Navigation")
		var map_button: Control = hud.get_node("Navigation/Map")
		var menu_button: Control = hud.get_node("Navigation/Menu")
		layout_ok = layout_ok and fits(map_button.get_global_rect(), navigation.get_global_rect()) and fits(menu_button.get_global_rect(), navigation.get_global_rect())
		layout_ok = layout_ok and not map_button.get_global_rect().grow(-1.0).intersects(menu_button.get_global_rect().grow(-1.0))
		var objective: Control = hud.get_node("Objective")
		var progress: Control = hud.get_node("Objective/Progress")
		layout_ok = layout_ok and fits(objective_label.get_global_rect(), objective.get_global_rect()) and fits(progress.get_global_rect(), objective.get_global_rect())
		layout_ok = layout_ok and not objective_label.get_global_rect().grow(-1.0).intersects(progress.get_global_rect().grow(-1.0))
		check(layout_ok, "Panels and long objective stay inside bounds without overlap at %s" % resolution)

	hud.queue_free()
	await process_frame
	finish()

func finish() -> void:
	print("HUD native: %d checks; %d failures." % [checks, failures.size()])
	for failure in failures:
		print("FAIL: " + failure)
	quit(0 if failures.is_empty() else 1)
