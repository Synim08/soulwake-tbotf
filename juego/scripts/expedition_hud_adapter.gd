extends RefCounted
## Presentación exclusivamente: no muta el estado ni introduce reglas/capacidad.
const Rules = preload("res://scripts/expedition_rules.gd")

static func present(snapshot: Dictionary) -> Dictionary:
	var campaign: Dictionary = snapshot.campaign
	var run: Dictionary = snapshot.active_run
	var village := run.is_empty()
	var cls: String = campaign["class"] if village else run["class"]
	var materials: Dictionary = campaign if village else run.bag
	var objective := "Prepara tu expedición" if village else "Avanza hasta el cartel del este"
	if village and not campaign.patio: objective = "Habilita el Patio de aventureros"
	if not village:
		if not run.battle.is_empty(): objective = "Resuelve el combate"
		elif not run.pending_offer.is_empty(): objective = "Elige tu recompensa"
		elif not run.cleared.has(run.node): objective = "Despeja el encuentro"
		elif run.node == "N2A" and not run.claimed.has("river"): objective = "Decide qué recoger en la ribera"
		elif run.node == "N3" and not run.claimed.has("rest"): objective = "Decide si descansar"
	return {"name":{"guardian":"Guardián","assassin":"Duelista","mage":"Piromante"}[cls],"level_text":"",
		"hp":38 if village else run.hp,"max_hp":38,"mp":12 if village else run.mp,"max_mp":12 if village else run.max_mp,
		"potions":(3 if campaign.kit == "small" else 2) if village else run.potions,"potion_enabled":not village and not run.battle.is_empty() and run.potions>0 and run.hp<38,
		"bag_used":materials.wood+materials.ore,"bag_capacity":0,"bag_label":"Almacén" if village else "Mochila","bag_risk":not village,
		"objective":objective,"progress":"Pueblo" if village else "%d etapas" % run.visited.size(),
		"hostile":not village and not run.cleared.has(run.node),"retreat_available":not village and Rules.ready_to_leave(run),"retreat_text":"En el pueblo" if village else "",
		"materials":[{"name":"Madera","amount":materials.wood},{"name":"Mineral","amount":materials.ore}]}
