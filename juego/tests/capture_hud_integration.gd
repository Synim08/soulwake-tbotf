extends SceneTree
var ui
var expedition
var directory := ""
func _initialize() -> void: call_deferred("run")
func shot(name: String) -> void:
	await process_frame
	await process_frame
	RenderingServer.viewport_set_update_mode(root.get_viewport_rid(), RenderingServer.VIEWPORT_UPDATE_ALWAYS)
	RenderingServer.force_draw(false)
	var error := root.get_texture().get_image().save_png(directory+"/"+name+".png")
	print("INTEGRATED_CAPTURE ",name," ",error)
func run() -> void:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--capture-dir="): directory=arg.trim_prefix("--capture-dir=")
	if directory.is_empty() or not OS.get_cmdline_user_args().has("--test-mode"): quit(1);return
	expedition=root.get_node("Expedition")
	expedition.state=load("res://scripts/expedition_rules.gd").fresh()
	ui=load("res://scenes/expedition.tscn").instantiate();root.add_child(ui)
	await shot("pueblo-windows")
	ui.act("patio");ui.act("start")
	for node in expedition.state.active_run.variation.encounters: expedition.state.active_run.variation.encounters[node]=0
	ui._sync()
	for i in 13:ui.world.step(Vector2i.RIGHT)
	ui.world.activate();ui.act("travel","N1")
	for i in 7:ui.world.step(Vector2i.RIGHT)
	ui.world.activate();ui.confirm_action.call()
	await shot("combate-windows")
	while not expedition.state.active_run.battle.is_empty():ui.act("attack")
	ui.act("skip")
	await create_timer(3.6).timeout
	await shot("exploracion-windows")
	ui.hud.set_bag_open(true)
	await shot("mochila-windows")
	quit(0)
