extends Node2D

const Combat = preload("res://combat_state.gd")
const Store = preload("res://run_store.gd")
const Hud = preload("res://prototype_hud.gd")
const FONT = preload("res://assets/fonts/AtkinsonHyperlegible-Bold.ttf")
const FIELD := Rect2(54, 85, 1044, 486)
const ENTRANCE := Vector2(120, 390)
const TRUNK := Rect2(488, 300, 152, 38)
const ENEMIES := [
	{"position": Vector2(700, 248), "hp": 48, "damage": 8, "guard_cost": 35.0, "color": Color("85a56c")},
	{"position": Vector2(850, 417), "hp": 58, "damage": 12, "guard_cost": 55.0, "color": Color("81a8a1")},
]
const PLAYER_RADIUS := 12.0
const ENEMY_RADIUS := 19.0
const PLAYER_SPEED := 242.4
const SLIME_JUMP_DURATION := 0.23 / 1.2
const SPRITE := [
	"....ddddd...", "...ddddddd..", "..ddhddhddd.", "..dhdhdddddd",
	"..ddssssd...", "...sesesd...", "...ssssss...", "....sss.....",
	"...CCCCc....", "..sCCCCCs...", "..sCCCCCs...", "...BBBBb....",
	"...CCCCc....", "...CCCCc....", "....ppp.....", "....p.p.....",
	"...dd.dd....", "...dd.dd....",
]
const SPRITE_COLORS := {
	"d": Color("262126"), "h": Color("5a4230"), "s": Color("e4be85"),
	"e": Color("855821"), "C": Color("ebe1af"), "c": Color("bdb079"),
	"B": Color("91663d"), "b": Color("644631"), "p": Color("424541"),
}

var combat = Combat.new()
var store = Store.new()
var hud: Control
var player := ENTRANCE
var aim := Vector2.RIGHT
var attack_direction := Vector2.RIGHT
var enemies: Array[Dictionary] = []
var next_attacker := 0
var guarding := false
var attack_heavy := false
var attack_time := 0.0
var attack_impact := 0.0
var attack_duration := 0.0
var attack_resolved := false
var attack_flash := 0.0
var pending_attack := ""
var trunk_broken := false
var paused := false
var pad_aim := false
var floating_text: Array[Dictionary] = []
var damage_numbers := true
var charge_numbers := false
var save_enabled := true
var save_pending := false
var save_timer := 0.0
var hud_timer := 0.0

func _ready() -> void:
	save_enabled = not OS.get_cmdline_user_args().has("--test-mode")
	get_tree().auto_accept_quit = false
	_register_inputs()
	hud = Hud.new()
	add_child(hud)
	hud.resume_requested.connect(_toggle_pause)
	hud.restart_requested.connect(restart)
	hud.show_damage_changed.connect(func(enabled: bool):
		damage_numbers = enabled
		if not enabled: floating_text.clear()
		_save())
	hud.show_charge_numbers_changed.connect(func(enabled: bool):
		charge_numbers = enabled
		_save())
	for saved in store.candidates() if save_enabled else []:
		if combat.restore(saved.combat, ENEMIES.size()):
			trunk_broken = saved.get("broken_trunk", false) == true
			damage_numbers = saved.get("damage_numbers", true) == true
			charge_numbers = saved.get("charge_numbers", false) == true
			if combat.status == "active":
				combat.message = "Has vuelto a la entrada. Los slimes vivos se recuperaron."
			break
	hud.set_preferences(damage_numbers, charge_numbers)
	_reset_positions()
	_sync()

func _reset_positions() -> void:
	player = ENTRANCE
	aim = Vector2.RIGHT
	enemies.clear()
	next_attacker = 0
	for spec in ENEMIES:
		enemies.append({
			"position": spec.position, "hp": spec.hp, "phase": "idle",
			"time": 0.0, "duration": 0.0, "from": spec.position,
			"target": spec.position, "alert": false,
		})
	guarding = false
	attack_time = 0.0
	attack_flash = 0.0
	pending_attack = ""
	floating_text.clear()

func restart() -> void:
	combat = Combat.new()
	trunk_broken = false
	_reset_positions()
	paused = false
	hud.set_paused(false)
	_save()
	_sync()

func _register_inputs() -> void:
	_bind("move_left", [KEY_A, KEY_LEFT], [], [_axis(JOY_AXIS_LEFT_X, -1.0)])
	_bind("move_right", [KEY_D, KEY_RIGHT], [], [_axis(JOY_AXIS_LEFT_X, 1.0)])
	_bind("move_up", [KEY_W, KEY_UP], [], [_axis(JOY_AXIS_LEFT_Y, -1.0)])
	_bind("move_down", [KEY_S, KEY_DOWN], [], [_axis(JOY_AXIS_LEFT_Y, 1.0)])
	_bind("light", [], [MOUSE_BUTTON_LEFT], [], [JOY_BUTTON_X])
	_bind("heavy", [KEY_F], [MOUSE_BUTTON_RIGHT], [], [JOY_BUTTON_Y])
	_bind("guard", [KEY_SPACE], [], [], [JOY_BUTTON_LEFT_SHOULDER])
	_bind("potion", [KEY_Q], [], [], [JOY_BUTTON_B])
	_bind("pause_combat", [KEY_ESCAPE], [], [], [JOY_BUTTON_START])

func _axis(axis: JoyAxis, value: float) -> InputEventJoypadMotion:
	var event := InputEventJoypadMotion.new()
	event.axis = axis
	event.axis_value = value
	return event

func _bind(action: StringName, keys: Array, mouse: Array, axes: Array, pad: Array = []) -> void:
	if InputMap.has_action(action):
		return
	InputMap.add_action(action, 0.25)
	for key in keys:
		var event := InputEventKey.new()
		event.physical_keycode = key
		InputMap.action_add_event(action, event)
	for button in mouse:
		var event := InputEventMouseButton.new()
		event.button_index = button
		InputMap.action_add_event(action, event)
	for event in axes:
		event.device = -1
		InputMap.action_add_event(action, event)
	for button in pad:
		var event := InputEventJoypadButton.new()
		event.device = -1
		event.button_index = button
		InputMap.action_add_event(action, event)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_combat") and not event.is_echo() and combat.status == "active":
		_toggle_pause()
		get_viewport().set_input_as_handled()
	if event is InputEventMouseMotion or event is InputEventMouseButton:
		pad_aim = false
	elif event is InputEventJoypadButton or (event is InputEventJoypadMotion and absf(event.axis_value) > 0.25):
		pad_aim = true

func _toggle_pause() -> void:
	if combat.status != "active":
		return
	paused = not paused
	pending_attack = ""
	if paused: _save()
	hud.set_paused(paused)
	_sync()

func _unhandled_input(event: InputEvent) -> void:
	if paused or combat.status != "active" or event.is_echo():
		return
	if event is InputEventMouseButton and get_global_mouse_position().y >= 624.0:
		return
	if event.is_action_pressed("heavy"):
		pending_attack = "heavy"
	elif event.is_action_pressed("light"):
		pending_attack = "light"

func _notification(what: int) -> void:
	if not is_instance_valid(hud):
		return
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		_save()
		get_tree().quit()
	elif what == NOTIFICATION_APPLICATION_FOCUS_OUT and combat.status == "active" and not paused:
		_toggle_pause()

func _physics_process(delta: float) -> void:
	if paused or combat.status != "active":
		return
	var movement := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	_update_aim()
	guarding = Input.is_action_pressed("guard") and attack_time <= 0.0 and combat.can_block()
	combat.tick(delta, guarding)
	if Input.is_action_just_pressed("potion"):
		if combat.drink(): _save()
	if attack_time <= 0.0 and not guarding and not pending_attack.is_empty():
		_start_attack(pending_attack == "heavy")
	pending_attack = ""
	var pace := PLAYER_SPEED
	if guarding: pace *= 0.58
	elif attack_time > 0.0: pace *= 0.45 if attack_heavy else 0.76
	player = _slide(player, movement * pace * delta, PLAYER_RADIUS)
	_separate_player()
	_advance_attack(delta)
	if combat.status == "active":
		_step_enemies(delta)
	_update_floats(delta)
	queue_redraw()
	hud_timer += delta
	if hud_timer >= 0.035 or combat.status != "active":
		hud_timer = 0.0
		_sync()
	save_timer += delta
	if save_timer >= 2.0:
		save_timer = 0.0
		if save_pending or combat.stamina < Combat.STAMINA_MAX: _save()

func _update_aim() -> void:
	if pad_aim:
		for device in Input.get_connected_joypads():
			var stick := Vector2(Input.get_joy_axis(device, JOY_AXIS_RIGHT_X), Input.get_joy_axis(device, JOY_AXIS_RIGHT_Y))
			if stick.length() > 0.25:
				aim = stick.normalized()
				break
	else:
		var target := get_global_mouse_position()
		if target.y < 624 and target.distance_to(player) > 3:
			aim = player.direction_to(target)

func _start_attack(heavy: bool) -> void:
	if not combat.spend_attack(heavy):
		return
	attack_heavy = heavy
	attack_direction = aim
	attack_duration = 0.69 if heavy else 0.28
	attack_impact = 0.32 if heavy else 0.095
	attack_time = attack_duration
	attack_resolved = false
	save_pending = true

func _advance_attack(delta: float) -> void:
	attack_flash = maxf(0.0, attack_flash - delta)
	if attack_time <= 0.0:
		return
	var elapsed := attack_duration - attack_time + delta
	attack_time = maxf(0.0, attack_time - delta)
	if not attack_resolved and elapsed >= attack_impact:
		attack_resolved = true
		attack_flash = 0.105 if attack_heavy else 0.075
		_resolve_attack()

func _resolve_attack() -> void:
	var reach := 92.0 if attack_heavy else 68.0
	var damage := 23 if attack_heavy else 12
	var aim_threshold := 0.44 if attack_heavy else 0.52
	var hit_enemy := false
	var defeated_now: Array[int] = []
	for index in enemies.size():
		var enemy := enemies[index]
		if combat.defeated.has(index) or enemy.hp <= 0:
			continue
		var distance := player.distance_to(enemy.position)
		if distance > reach + ENEMY_RADIUS or attack_direction.dot(player.direction_to(enemy.position)) < aim_threshold:
			continue
		if not trunk_broken and _trunk_blocks(player, enemy.position):
			continue
		hit_enemy = true
		var applied := mini(enemy.hp, damage)
		enemy.hp -= applied
		enemy.alert = true
		if enemy.phase == "idle": enemy.phase = "chase"
		_float_damage(enemy.position, applied, Color("f7da9a"))
		if enemy.hp == 0: defeated_now.append(index)
	var was_broken := trunk_broken
	var trunk_point := player.clamp(TRUNK.position, TRUNK.end)
	if attack_heavy and not trunk_broken and player.distance_to(trunk_point) <= reach and attack_direction.dot(player.direction_to(trunk_point)) > aim_threshold:
		trunk_broken = true
		combat.message = "Tronco roto. El centro queda abierto."
	if hit_enemy:
		combat.register_effective_attack()
		for index in defeated_now: combat.mark_defeated(index, ENEMIES.size())
		_save()
	elif trunk_broken and not was_broken:
		_save()

func _trunk_blocks(from: Vector2, to: Vector2) -> bool:
	var steps := maxi(1, ceili(from.distance_to(to) / 8.0))
	for index in range(1, steps):
		if TRUNK.has_point(from.lerp(to, float(index) / steps)):
			return true
	return false

func _slide(from: Vector2, motion: Vector2, radius: float) -> Vector2:
	var bounds := FIELD.grow(-radius)
	var result := from
	for offset: Vector2 in [Vector2(motion.x, 0), Vector2(0, motion.y)]:
		var next := (result + offset).clamp(bounds.position, bounds.end)
		if trunk_broken or not TRUNK.grow(radius).has_point(next):
			result = next
	return result

func _separate_player() -> void:
	for index in enemies.size():
		if combat.defeated.has(index) or enemies[index].phase == "air":
			continue
		var enemy_point: Vector2 = enemies[index].position
		var distance := player.distance_to(enemy_point)
		var minimum := PLAYER_RADIUS + ENEMY_RADIUS - 3.0
		if distance > 0.001 and distance < minimum:
			player = _slide(player, enemy_point.direction_to(player) * (minimum - distance), PLAYER_RADIUS)

func _step_enemies(delta: float) -> void:
	var attack_busy := false
	for index in enemies.size():
		if not combat.defeated.has(index) and enemies[index].phase in ["tell", "air", "recover"]:
			attack_busy = true
	var first := next_attacker
	for turn in enemies.size():
		var index := (first + turn) % enemies.size()
		if combat.defeated.has(index) or combat.status != "active":
			continue
		var enemy := enemies[index]
		var distance := player.distance_to(enemy.position)
		match enemy.phase:
			"idle":
				if distance < 440:
					enemy.phase = "chase"
					enemy.alert = true
			"chase":
				if distance < 146 and not attack_busy:
					enemy.phase = "tell"
					enemy.time = 0.82 if index == 0 else 1.04
					enemy.duration = enemy.time
					var inner := FIELD.grow(-ENEMY_RADIUS)
					enemy.target = _landing_position(player.clamp(inner.position, inner.end))
					next_attacker = (index + 1) % enemies.size()
					attack_busy = true
				elif distance > (104.0 if attack_busy else 54.0):
					_chase(index, delta)
			"tell":
				enemy.time -= delta
				if enemy.time <= 0.0:
					enemy.phase = "air"
					enemy.duration = SLIME_JUMP_DURATION
					enemy.time = enemy.duration
					enemy.from = enemy.position
			"air":
				enemy.time = maxf(0.0, enemy.time - delta)
				enemy.position = enemy.from.lerp(enemy.target, 1.0 - enemy.time / enemy.duration)
				if enemy.time <= 0.0:
					enemy.phase = "recover"
					enemy.time = 0.72
					_enemy_impact(index)
			"recover":
				enemy.time -= delta
				if enemy.time <= 0.0:
					enemy.phase = "chase"

func _landing_position(point: Vector2) -> Vector2:
	var obstacle := TRUNK.grow(ENEMY_RADIUS + 1.0)
	if trunk_broken or not obstacle.has_point(point):
		return point
	var closest := Vector2(obstacle.position.x, point.y)
	for edge: Vector2 in [Vector2(obstacle.end.x,point.y), Vector2(point.x,obstacle.position.y), Vector2(point.x,obstacle.end.y)]:
		if point.distance_squared_to(edge) < point.distance_squared_to(closest):
			closest = edge
	return closest

func _chase(index: int, delta: float) -> void:
	var enemy := enemies[index]
	var point: Vector2 = enemy.position
	var target := player
	if not trunk_broken and _trunk_blocks(point, target):
		var margin := ENEMY_RADIUS + 9
		var padded := TRUNK.grow(margin)
		var waypoints := [padded.position, Vector2(padded.end.x,padded.position.y), padded.end, Vector2(padded.position.x,padded.end.y)]
		var best := INF
		for waypoint: Vector2 in waypoints:
			if _trunk_blocks(point, waypoint):
				continue
			var score := point.distance_to(waypoint) + waypoint.distance_to(player)
			if score < best and point.distance_to(waypoint) > 4:
				target = waypoint
				best = score
	var motion := point.direction_to(target) * (101.0 if index == 0 else 86.0)
	for other_index in enemies.size():
		if index == other_index or combat.defeated.has(other_index):
			continue
		var other: Vector2 = enemies[other_index].position
		if point.distance_to(other) < 47:
			motion += other.direction_to(point) * 76
	enemy.position = _slide(point, motion * delta, ENEMY_RADIUS)

func _enemy_impact(index: int) -> void:
	var enemy := enemies[index]
	var radius := 40.0 if index == 0 else 49.0
	if player.distance_to(enemy.position) > radius + PLAYER_RADIUS:
		return
	var source: Vector2 = enemy.from
	var to_source := player.direction_to(source)
	var facing := aim.dot(to_source) >= 0.25
	var result: Dictionary = combat.receive_hit(ENEMIES[index].damage, ENEMIES[index].guard_cost, guarding and facing)
	if result.ignored:
		return
	_float_damage(player, result.damage, Color("ff9c83"))
	var knockback := 12.0 if result.blocked else 24.0
	player = _slide(player, source.direction_to(player) * knockback, PLAYER_RADIUS)
	if result.broken:
		guarding = false
		attack_time = 0.0
	_save()
	_sync()

func _float_damage(position_at: Vector2, amount: int, color: Color) -> void:
	if damage_numbers:
		floating_text.append({"position": position_at + Vector2(-8,-36), "amount": amount, "color": color, "time": 0.75})

func _update_floats(delta: float) -> void:
	for index in range(floating_text.size() - 1, -1, -1):
		var item := floating_text[index]
		item.position.y -= 34.0 * delta
		item.time -= delta
		if item.time <= 0.0: floating_text.remove_at(index)

func _sync() -> void:
	var mode := "Listo"
	if combat.guard_break > 0.0: mode = "Guardia rota"
	elif guarding: mode = "Bloqueando"
	elif attack_time > 0.0: mode = "Ataque pesado" if attack_heavy else "Ataque ligero"
	hud.sync(combat.hud_data(ENEMIES.size(), mode))
	queue_redraw()

func _save() -> void:
	if not save_enabled:
		return
	save_pending = not store.write(combat.snapshot(), trunk_broken, damage_numbers, charge_numbers)
	if save_pending: combat.message = "No se pudo guardar la prueba."

func _draw() -> void:
	_draw_trunk()
	for index in enemies.size():
		if combat.defeated.has(index): continue
		var enemy := enemies[index]
		if enemy.phase in ["tell", "air"]:
			var radius := 40.0 if index == 0 else 49.0
			var warning_progress: float = 1.0 - enemy.time / enemy.duration if enemy.phase == "tell" else 1.0
			draw_circle(enemy.target, radius, Color(0.74, 0.21, 0.17, 0.16 + warning_progress*0.16))
			draw_arc(enemy.target, radius, 0, TAU, 40, Color(1.0, 0.53, 0.40, 0.8), 2.0, true)
			draw_arc(enemy.target, radius + 4, -PI/2.0, -PI/2.0+TAU*warning_progress, 32, Color("ffc49b"), 2.0, true)
	for index in enemies.size():
		if not combat.defeated.has(index):
			_draw_slime(index)
	_draw_player()
	for item in floating_text:
		var color: Color = item.color
		color.a = minf(1.0, item.time * 3.0)
		draw_string_outline(FONT, item.position, str(item.amount), HORIZONTAL_ALIGNMENT_LEFT, -1, 20, 3, Color(0.09,0.09,0.08,color.a))
		draw_string(FONT, item.position, str(item.amount), HORIZONTAL_ALIGNMENT_LEFT, -1, 20, color)

func _draw_trunk() -> void:
	if trunk_broken:
		for patch in [Rect2(498,320,12,10), Rect2(525,339,18,5), Rect2(552,327,10,9), Rect2(600,313,15,6), Rect2(630,330,21,7)]:
			draw_rect(patch, Color("644731"))
			draw_rect(Rect2(patch.position, Vector2(patch.size.x - 3, 2)), Color("aa7650"))
		return
	draw_rect(Rect2(TRUNK.position + Vector2(2,7), TRUNK.size+Vector2(7,2)), Color("1d332b"))
	draw_rect(TRUNK, Color("553e2f"))
	draw_rect(Rect2(494,302,140,31), Color("7b5339"))
	draw_rect(Rect2(497,305,119,6), Color("a8784d"))
	draw_rect(Rect2(512,318,123,4), Color("66432f"))
	draw_rect(Rect2(545,328,79,4), Color("9b6944"))
	draw_rect(Rect2(493,310,25,10), Color("53704a"))
	draw_rect(Rect2(507,306,22,9), Color("698254"))
	draw_rect(Rect2(554,305,14,5), Color("698254"))
	draw_rect(Rect2(617,302,17,32), Color("b38658"))
	draw_rect(Rect2(621,306,10,24), Color("926542"))
	draw_rect(Rect2(624,311,5,14), Color("72513a"))

func _draw_player() -> void:
	var p := player.round()
	var shadow := Color(0.05,0.10,0.08,0.65)
	draw_set_transform(p + Vector2(0,4), 0, Vector2(1.0,0.42))
	draw_circle(Vector2.ZERO, 18, shadow)
	draw_set_transform(Vector2.ZERO)
	var origin := p - Vector2(18, 50)
	var flash: bool = combat.invulnerable > 0 and fmod(combat.invulnerable,0.14) > 0.07
	for y in SPRITE.size():
		for x in SPRITE[y].length():
			var source_x: int = x if aim.x >= 0 else SPRITE[y].length()-1-x
			var color: Color = SPRITE_COLORS.get(SPRITE[y][source_x], Color.TRANSPARENT)
			if color.a > 0:
				draw_rect(Rect2(origin+Vector2(x*3, y*3),Vector2(3,3)),color.lightened(0.45) if flash else color)
	var angle := attack_direction.angle() if attack_time > 0 else aim.angle()
	if guarding:
		var shield := p + aim*20.0
		draw_arc(p, 24, angle-0.8, angle+0.8, 14, Color("9cdec5"), 4.0, true)
		draw_circle(shield, 5, Color("e8d091"))
	elif attack_flash > 0:
		var radius := 91.0 if attack_heavy else 67.0
		draw_arc(p, radius, angle-0.89, angle+0.89, 38, Color(1,0.79,0.43,0.8), 5.0 if attack_heavy else 3.0, true)
		draw_arc(p, radius-7, angle-0.75, angle+0.72, 30, Color(1,0.95,0.68,0.35), 2.0, true)
	else:
		var weapon_start := p + Vector2(0,-11) + Vector2.from_angle(angle)*13.0
		var weapon_end := weapon_start+Vector2.from_angle(angle)*(25.0 if attack_time > 0 else 15.0)
		draw_line(weapon_start, weapon_end, Color("6b6049"), 6.0)
		draw_line(weapon_start, weapon_end, Color("dccba3"), 3.0)
	if combat.guard_break > 0:
		draw_string_outline(FONT, p+Vector2(-41,-58), "Sin guardia", HORIZONTAL_ALIGNMENT_LEFT, -1, 14, 3, Color("35251c"))
		draw_string(FONT,p+Vector2(-41,-58),"Sin guardia",HORIZONTAL_ALIGNMENT_LEFT,-1,14,Color("ffc582"))
	if not paused and combat.status == "active":
		var indicator := p + aim*30.0
		draw_circle(indicator, 2.5, Color("e1d8ae"))

func _draw_slime(index: int) -> void:
	var enemy := enemies[index]
	var base: Vector2 = enemy.position.round()
	var elevation := 0.0
	if enemy.phase == "air": elevation = sin(PI * (1.0 - enemy.time/enemy.duration))*43
	var p := base - Vector2(0,roundf(elevation))
	var width := 47.0 if enemy.phase == "tell" else 41.0
	var height := 17.0 if enemy.phase == "tell" else 26.0
	if enemy.phase == "air": height = 33
	var tone: Color = ENEMIES[index].color
	draw_set_transform(base + Vector2(0,3), 0, Vector2(1.0,0.4))
	draw_circle(Vector2.ZERO, width*0.55, Color(0.04,0.10,0.07,0.57))
	draw_set_transform(Vector2.ZERO)
	draw_rect(Rect2(p+Vector2(-width/2, -height+6),Vector2(width,height-6)),tone.darkened(0.56))
	draw_rect(Rect2(p+Vector2(-width/2+4, -height+2),Vector2(width-8,height-4)),tone.darkened(0.23))
	draw_rect(Rect2(p+Vector2(-width/2+9, -height),Vector2(width-18,height-7)),tone)
	draw_rect(Rect2(p+Vector2(-9,-height+4),Vector2(14,3)),tone.lightened(0.32))
	var eye_height := -height+10
	draw_rect(Rect2(p+Vector2(-9,eye_height),Vector2(4,5)),Color("22352f"))
	draw_rect(Rect2(p+Vector2(6,eye_height),Vector2(4,5)),Color("22352f"))
	if enemy.alert:
		var bar := Rect2(p+Vector2(-22,-height-13),Vector2(44,5))
		draw_rect(bar.grow(1), Color("282421"))
		draw_rect(Rect2(bar.position,Vector2(bar.size.x*float(enemy.hp)/float(ENEMIES[index].hp),bar.size.y)),Color("e7b27b"))
