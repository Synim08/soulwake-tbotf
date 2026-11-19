extends SceneTree

const Rules = preload("res://scripts/expedition_rules.gd")
const Maps = preload("res://scripts/expedition_maps.gd")
const Adapter = preload("res://scripts/expedition_hud_adapter.gd")
const Store = preload("res://scripts/expedition_store.gd")
class ScratchStore extends Store:
	func path() -> String: return "user://hud_integration_test_only.json"

var checks := 0
var failures: Array[String] = []
var ui
var expedition

func _initialize() -> void: call_deferred("run")
func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok: failures.append(message);push_error(message)
func settle() -> void:
	await process_frame
	await process_frame
func synced(message: String) -> void:
	var expected: Dictionary = Adapter.present(expedition.state)
	check(ui.hud.state.hp == expected.hp and ui.hud.state.mp == expected.mp and ui.hud.state.potions == expected.potions and ui.hud.state.bag_used == expected.bag_used and ui.hud.state.retreat_available == expected.retreat_available,message)
func walk_to(target: Vector2i) -> void:
	# Walk through the actual map, using the existing world.step interface.
	var start: Vector2i = ui.world.point()
	var queue: Array[Vector2i] = [start]
	var previous := {start:start}
	while not queue.is_empty():
		var point: Vector2i = queue.pop_front()
		if point == target: break
		for direction in [Vector2i.LEFT,Vector2i.RIGHT,Vector2i.UP,Vector2i.DOWN]:
			var next: Vector2i = point+direction
			if not previous.has(next) and Maps.walkable(ui.world.region(),next):
				previous[next]=point;queue.append(next)
	check(previous.has(target),"Path to interaction exists")
	if not previous.has(target): return
	var steps: Array[Vector2i] = []
	var cursor := target
	while cursor != start:
		steps.push_front(cursor-previous[cursor]);cursor=previous[cursor]
	for step in steps: ui.world.step(step)
func travel(node: String) -> void:
	walk_to(Vector2i(15,6))
	ui.world.activate()
	check(ui.mode == "map" and ui.world.nearest == "exit","Map action reached through exit interaction")
	ui.act("travel",node)
	synced("HUD syncs after travel "+node)
func fight(use_potion: bool = false) -> void:
	walk_to(Vector2i(9,6));ui.world.activate()
	check(ui.mode == "confirm","Enemy interaction requests confirmation")
	ui.confirm_action.call()
	check(ui.mode == "battle" and not ui.hud.visible and not ui.world.enabled,"Combat locks exploration HUD and movement")
	if use_potion:
		ui.act("attack")
		var count: int = expedition.state.active_run.potions
		var key := InputEventKey.new();key.physical_keycode=KEY_Q;key.pressed=true
		ui._input(key)
		check(expedition.state.active_run.potions==count-1,"Q uses the actual potion command in combat")
	var turns := 0
	while not expedition.state.active_run.is_empty() and not expedition.state.active_run.battle.is_empty() and turns<100:
		var run_state: Dictionary = expedition.state.active_run
		var action := "attack"
		if run_state.hp<=18 and run_state.potions>0: action="potion"
		elif Rules.intention(expedition.state).begins_with("Golpe pesado"): action="defend"
		ui.act(action);turns+=1
	check(turns<100,"Combat reaches a result")
	if not expedition.state.active_run.is_empty() and not expedition.state.active_run.pending_offer.is_empty(): ui.act("skip")
	synced("HUD syncs combat damage, supplies and rewards")

func run() -> void:
	expedition=root.get_node("Expedition")
	check(expedition.testing,"Test mode isolates campaign writes")
	expedition.state=Rules.fresh()
	ui=load("res://scenes/expedition.tscn").instantiate();root.add_child(ui)
	await settle()
	check(ui.hud.state.bag_label=="Almacén" and not ui.hud.state.bag_risk and ui.hud.get_node("Hero/Level").text.is_empty(),"Village displays stored resources without a fictitious level")
	check(ui.hud.get_node("Hero").get_global_rect().encloses(ui.hud.get_node("Hero/Potion").get_global_rect()),"Disabled exploration potion remains inside the character panel")
	ui.hud.get_node("Navigation/Menu").pressed.emit()
	check(ui.mode=="pause" and ui.overlay.visible and not ui.world.enabled,"HUD menu opens real pause interface")
	ui.close_menu();ui.hud.get_node("Navigation/Map").pressed.emit()
	check(ui.mode=="map","HUD map opens actual route menu")
	ui.close_menu();ui.hud.set_bag_open(true)
	check(not ui.world.enabled,"Expanded bag pauses walking")
	ui.hud.set_bag_open(false);check(ui.world.enabled,"Closing bag restores walking")
	ui.act("patio");ui.act("start")
	for node in expedition.state.active_run.variation.encounters: expedition.state.active_run.variation.encounters[node]=0
	ui._sync()
	check(ui.hud.state.bag_capacity==0 and ui.hud.state.level_text=="" and ui.hud.state.name=="Guardián","HUD adds neither capacity nor character-level rules")
	var before: Dictionary = expedition.state.duplicate(true)
	ui.hud.potion_requested.emit()
	check(expedition.state==before,"Pocion shortcut outside combat does not change rules or inventory")
	travel("N1")
	walk_to(Vector2i(4,4));ui.world.activate()
	check(expedition.state.active_run.bag.wood==1,"Chest pickup is reflected in real inventory")
	synced("HUD updates after collecting wood")
	fight(true)
	travel("N2A");walk_to(Vector2i(10,6));ui.world.activate();ui.act("interact","event_wood")
	var scratch := ScratchStore.new()
	check(scratch.write(expedition.state),"Current expedition is saved to an isolated test slot")
	var saved: Dictionary = scratch.read()
	check(saved==expedition.state,"Save/reload preserves the expedition")
	expedition.state=saved;ui._sync();synced("HUD reconstructs after reloading")
	var cargo: Dictionary = expedition.state.active_run.bag.duplicate()
	ui._retreat();check(ui.mode=="confirm","Retreat requires confirmation")
	ui.confirm_action.call()
	check(expedition.state.active_run.is_empty() and expedition.state.campaign.wood==cargo.wood and ui.mode=="result","Retreat deposits carried materials through existing rules")
	ui.act("ack");check(ui.hud.visible and not ui.hud.state.bag_risk,"Return restores village HUD")
	ui.act("start")
	for node in expedition.state.active_run.variation.encounters: expedition.state.active_run.variation.encounters[node]=0
	travel("N1");fight();travel("N2A");walk_to(Vector2i(10,6));ui.world.activate();ui.act("interact","event_wood")
	travel("N3");walk_to(Vector2i(9,6));ui.world.activate();ui.act("interact","rest_hp")
	travel("N4A");fight();walk_to(Vector2i(13,5));ui.world.activate()
	travel("N5");walk_to(Vector2i(9,6));ui.world.activate();ui.act("skip")
	travel("N6");fight()
	check(expedition.state.last_result.get("outcome")=="won" and expedition.state.campaign.boss and ui.mode=="result","Full expedition reaches victory with HUD transitions")
	ui.act("ack");synced("Victory deposits resources and refreshes village HUD")
	# Defeat transition also loses the real carried inventory.
	ui.act("start")
	expedition.state.active_run.variation.encounters["N1"]=0
	travel("N1");walk_to(Vector2i(9,6));ui.world.activate();ui.confirm_action.call()
	expedition.state.active_run.hp=1;expedition.state.active_run.bag.wood=3;expedition.state.active_run.potions=0;ui._sync()
	ui.act("attack")
	check(expedition.state.active_run.is_empty() and expedition.state.last_result.outcome=="lost" and expedition.state.last_result.lost_wood==3,"Defeat uses original loss rules and result view")
	for suffix in ["",".bak",".tmp"]:
		if FileAccess.file_exists(scratch.path()+suffix): DirAccess.remove_absolute(scratch.path()+suffix)
	ui.queue_free();await process_frame
	print("HUD integration: %d checks; %d failures." % [checks,failures.size()])
	quit(0 if failures.is_empty() else 1)
