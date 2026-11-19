class_name ExpeditionRules
extends RefCounted

const CLASSES := {
	"guardian": {"name": "Guerrero · Guardián", "description": "Defender devuelve 3 de daño tras recibir un golpe.", "weapon": "Espada de guardia"},
	"assassin": {"name": "Asesino · Duelista", "description": "Cada tercer ataque es crítico. El contador es visible.", "weapon": "Dagas del sendero"},
	"mage": {"name": "Mago · Piromante", "description": "Chispa aplica quemadura; el bastón prolonga su duración.", "weapon": "Bastón de brasas"}}
const NODES := {
	"N0": {"name": "Entrada del sendero", "description": "Lugar despejado. Consulta la mochila y elige avanzar o volver.", "enemy": "", "next": ["N1"]},
	"N1": {"name": "Claro de savia", "description": "Slime · 2 madera y una mejora. Cofre opcional: 1 madera.", "enemy": "slime", "next": ["N2A", "N2B"]},
	"N2A": {"name": "Ribera de hierbas", "description": "Ruta segura: curar 8 PV o recoger 2 madera.", "enemy": "", "next": ["N3"]},
	"N2B": {"name": "Linde del bosque", "description": "Lobo · 2 mineral. Debes vencer para regresar.", "enemy": "wolf", "next": ["N3"]},
	"N3": {"name": "Campamento abandonado", "description": "Un descanso: recuperar 10 PV o 6 PM.", "enemy": "", "next": ["N4A", "N4B"]},
	"N4A": {"name": "Ruinas del puesto forestal", "description": "Murciélago · 2 madera, 2 mineral y contacto con Mara.", "enemy": "bat", "next": ["N5"]},
	"N4B": {"name": "Claro de tala", "description": "Riesgo alto: lobo veterano · 2 madera, 4 mineral y arma compatible.", "enemy": "veteran", "next": ["N5"]},
	"N5": {"name": "Umbral de raíces", "description": "Alijo: 2 madera, 2 mineral y mejora. Última oportunidad de regresar.", "enemy": "", "next": ["N6"]},
	"N6": {"name": "Santuario de raíces", "description": "Jefe: Guardián del Sendero. Sin huida durante combate.", "enemy": "guardian", "next": []}}
const ENEMIES := {
	"slime": {"name": "Slime de savia", "hp": 14, "attack": 5, "defense": 0},
	"wolf": {"name": "Lobo del sendero", "hp": 24, "attack": 7, "defense": 1},
	"bat": {"name": "Murciélago de ruina", "hp": 18, "attack": 6, "defense": 0},
	"veteran": {"name": "Lobo veterano", "hp": 36, "attack": 8, "defense": 2},
	"guardian": {"name": "Guardián del Sendero", "hp": 64, "attack": 10, "defense": 3}}
const UPGRADES := {
	"G01": {"name": "Escudo de espinas", "description": "+2 al daño devuelto al defender.", "class": "guardian"},
	"G02": {"name": "Golpe preparado", "description": "Defender prepara +3 al próximo ataque. No acumula cargas.", "class": "guardian"},
	"G03": {"name": "Sello del vigía", "description": "+1 PM al defender.", "class": "guardian"},
	"A01": {"name": "Filo certero", "description": "+0,5 al multiplicador de críticos.", "class": "assassin"},
	"A02": {"name": "Paso ligero", "description": "Recibes 2 menos de daño al atacar; mínimo 1.", "class": "assassin"},
	"A03": {"name": "Ritmo mortal", "description": "Cada segundo ataque es crítico.", "class": "assassin"},
	"M01": {"name": "Ascua persistente", "description": "+1 acción de quemadura.", "class": "mage"},
	"M02": {"name": "Canalización", "description": "Chispa cuesta 1 PM menos.", "class": "mage"},
	"M03": {"name": "Núcleo ardiente", "description": "+1 al daño de quemadura.", "class": "mage"},
	"C01": {"name": "Cantimplora", "description": "Recuperas 2 PV tras vencer un combate.", "class": "common"},
	"C02": {"name": "Bolsa de vendas", "description": "+4 a la curación de pociones.", "class": "common"},
	"C03": {"name": "Reserva arcana", "description": "+3 PM máximos y recuperar 3 PM al adquirirla.", "class": "common"}}
const WEAPONS := {
	"basic": {"name": "Arma básica", "description": "Equipo básico de tu especialización."},
	"power": {"name": "Variante de potencia", "description": "+2 ataque para Guardián/Duelista; +2 daño directo de Chispa para Piromante."},
	"tactical": {"name": "Variante táctica", "description": "+2 devolución Guardián; +0,5 crítico Duelista; +1 duración de quemadura Piromante."}}

static func fresh() -> Dictionary:
	return {"schema": 1, "mode": "roguelite", "sequence": 0,
		"campaign": {"wood": 0, "ore": 0, "patio": false, "mara": false, "boss": false, "botica": false, "arsenal": false, "class": "guardian", "kit": "normal", "weapon": "basic"},
		"active_run": {}, "last_result": {}}

static func stats(run: Dictionary) -> Dictionary:
	var u: Array = run.upgrades
	var cls: String = run["class"]
	var weapon: String = run.weapon
	return {"attack": (12 if cls == "guardian" else (11 if cls == "assassin" else 9)) + (2 if weapon == "power" and cls != "mage" else 0),
		"magic": 17 + (2 if weapon == "power" and cls == "mage" else 0) if cls == "mage" else 13,
		"magic_cost": 3 if u.has("M02") else 4, "guard_mp": 4 if u.has("G03") else 3,
		"reflect": 3 + (2 if u.has("G01") else 0) + (2 if weapon == "tactical" and cls == "guardian" else 0),
		"critical_multiplier": 2.5 + (0.5 if u.has("A01") else 0.0) + (0.5 if weapon == "tactical" and cls == "assassin" else 0.0),
		"critical_interval": 2 if u.has("A03") else 3,
		"burn_duration": 3 + (1 if u.has("M01") else 0) + (1 if weapon == "tactical" and cls == "mage" else 0),
		"burn_damage": 3 if u.has("M03") else 2,
		"potion_heal": int(run.potion_heal) + (4 if u.has("C02") else 0), "max_mp": int(run.max_mp)}

static func ready_to_leave(run: Dictionary) -> bool:
	if not run.battle.is_empty() or not run.pending_offer.is_empty() or not run.cleared.has(run.node):
		return false
	if run.node == "N2A" and not run.claimed.has("river"):
		return false
	if run.node == "N3" and not run.claimed.has("rest"):
		return false
	return true

static func choices(state: Dictionary) -> Array:
	if state.active_run.is_empty() or not ready_to_leave(state.active_run):
		return []
	return NODES[state.active_run.node].next.duplicate()

static func offer_options(run: Dictionary) -> Array:
	return run.offers.get(run.pending_offer, []).duplicate()

static func command(state: Dictionary, action: String, value: String = "") -> String:
	var c: Dictionary = state.campaign
	var r: Dictionary = state.active_run
	if action == "ack":
		if not state.last_result.is_empty():
			state.last_result.ack = true
		return "Puedes preparar la siguiente salida."
	if r.is_empty():
		match action:
			"patio":
				c.patio = true
				return "Patio de aventureros habilitado. Tres especializaciones disponibles."
			"class":
				if c.patio and CLASSES.has(value):
					c["class"] = value
					return "Especialización preparada: " + CLASSES[value].name
			"kit":
				if value == "normal" or (value == "small" and c.botica):
					c.kit = value
					return "Suministros preparados."
			"weapon":
				if value == "basic" or (value == "tactical" and c.arsenal):
					c.weapon = value
					return "Arma inicial preparada."
			"build":
				return _build(c, value)
			"start":
				if not c.patio:
					return "Habilita primero el Patio de aventureros."
				state.sequence += 1
				var seed_value := int(Time.get_ticks_usec() % 2147483647)
				state.active_run = {"id": "%d-%d" % [state.sequence, seed_value], "seed": seed_value,
					"node": "N0", "x": 2, "y": 6, "class": c["class"], "kit": c.kit, "weapon": c.weapon,
					"hp": 38, "mp": 12, "max_mp": 12, "potions": 3 if c.kit == "small" else 2,
					"potion_heal": 12 if c.kit == "small" else 22,
					"bag": {"wood": 0, "ore": 0}, "upgrades": [], "visited": ["N0"], "cleared": ["N0"],
					"claimed": [], "offers": {}, "pending_offer": "", "battle": {}, "mara_contact": false}
				var rng := RandomNumberGenerator.new()
				rng.seed = seed_value
				var encounters := {}
				for node in ["N1","N2B","N4A","N4B"]: encounters[node] = rng.randi_range(0,1)
				state.active_run.variation = {"encounters": encounters, "event": ["merchant","altar","traveler"][rng.randi_range(0,2)]}
				state.active_run.event_claimed = false
				state.active_run.traveler = false
				state.last_result = {}
				return "Comienza el Bosque del Sendero. Los materiales de tu mochila están en riesgo."
		return "Esta opción no está disponible en el pueblo."
	if action == "travel":
		if not choices(state).has(value):
			return "Despeja este lugar y resuelve las decisiones pendientes antes de avanzar."
		r.node = value
		r.x = 2
		r.y = 6
		r.visited.append(value)
		if NODES[value].enemy.is_empty():
			r.cleared.append(value)
		return NODES[value].name
	if action == "retreat":
		if not ready_to_leave(r):
			return "Solo puedes regresar desde un lugar despejado y sin decisiones pendientes."
		return _finish(state, "retired")
	if action in ["attack", "magic", "defend", "potion"]:
		return _act(state, action)
	if not r.battle.is_empty():
		return "Resuelve primero el combate. No hay huida durante el combate."
	if action == "event":
		return _event(r,value)
	if action == "choose":
		if not offer_options(r).has(value):
			return "Esa opción no pertenece a la oferta actual."
		if r.pending_offer == "W1":
			r.weapon = value
		else:
			if r.pending_offer == "E1":
				r.hp -= 8
				r.event_claimed = true
			r.upgrades.append(value)
			if value == "C03":
				r.max_mp = 15
				r.mp = mini(15, r.mp + 3)
		r.claimed.append(r.pending_offer)
		r.pending_offer = ""
		return "Elección guardada: " + (UPGRADES[value].name if UPGRADES.has(value) else WEAPONS[value].name)
	if action == "skip":
		if not r.pending_offer.is_empty():
			if r.pending_offer == "E1": r.event_claimed = true
			r.claimed.append(r.pending_offer)
			r.pending_offer = ""
			return "Oferta rechazada; no se puede volver a elegir."
		if r.node == "N2A" and not r.claimed.has("river"):
			r.claimed.append("river")
			return "Dejas las hierbas y sigues tu camino."
		if r.node == "N3" and not r.claimed.has("rest"):
			r.claimed.append("rest")
			return "Decides continuar sin descansar."
		return "No hay una decisión pendiente que omitir."
	if not r.pending_offer.is_empty():
		return "Elige o rechaza la recompensa pendiente."
	if action == "interact":
		return _interact(state, value)
	return "Esta opción no está disponible durante la expedición."

static func _build(c: Dictionary, id: String) -> String:
	if not id in ["botica", "arsenal"]:
		return "Proyecto desconocido."
	if c[id]:
		return "Este edificio ya está construido."
	if id == "botica" and not c.mara:
		return "Rescata a Mara en las ruinas y regresa al pueblo."
	if id == "arsenal" and not c.boss:
		return "Necesitas vencer al Guardián del Sendero."
	var wood := 4 if id == "botica" else 8
	var ore := 2 if id == "botica" else 6
	if c.wood < wood or c.ore < ore:
		return "Necesitas %d madera y %d mineral." % [wood, ore]
	c.wood -= wood
	c.ore -= ore
	c[id] = true
	return "¡Proyecto completado! " + ("Botica de campaña: nuevo kit de suministros." if id == "botica" else "Banco de equipo: armas tácticas iniciales.")

static func _interact(state: Dictionary, target: String) -> String:
	var r: Dictionary = state.active_run
	match target:
		"enemy":
			if r.cleared.has(r.node):
				return "Este lugar ya está despejado."
			var id: String = NODES[r.node].enemy
			if id.is_empty():
				return "No hay enemigo en este lugar."
			r.battle = {"enemy": id, "hp": ENEMIES[id].hp, "max_hp": ENEMIES[id].hp, "turn": 0,
				"variant": int(r.get("variation",{}).get("encounters",{}).get(r.node,0)), "phase": 0, "phase_turn": 0, "guard": false, "burn_turns": 0, "focus": 0, "prepared": false,
				"message": "Lee la intención enemiga antes de actuar."}
			return "Comienza el combate contra " + ENEMIES[id].name
		"chest":
			if r.node != "N1" or r.claimed.has("chest"):
				return "No queda ningún cofre por recoger aquí."
			r.claimed.append("chest")
			r.bag.wood += 1
			return "Cofre del desvío: +1 madera en riesgo."
		"event_wood", "event_heal":
			if r.node != "N2A" or r.claimed.has("river"):
				return "Las hierbas ya se han resuelto."
			if target == "event_heal" and r.hp >= 38:
				return "Ya tienes toda la vida."
			r.claimed.append("river")
			if target == "event_wood":
				r.bag.wood += 2
				return "Recuperas 2 madera."
			r.hp = mini(38, r.hp + 8)
			return "Las hierbas restauran hasta 8 PV."
		"rest_hp", "rest_mp":
			if r.node != "N3" or r.claimed.has("rest"):
				return "El descanso ya se ha resuelto."
			if (target == "rest_hp" and r.hp >= 38) or (target == "rest_mp" and r.mp >= r.max_mp):
				return "Ese recurso ya está al máximo."
			r.claimed.append("rest")
			if target == "rest_hp":
				r.hp = mini(38, r.hp + 10)
			else:
				r.mp = mini(r.max_mp, r.mp + 6)
			return "Descanso único consumido: hasta 10 PV o 6 PM recuperados."
		"mara":
			if r.node != "N4A" or not r.cleared.has("N4A"):
				return "Despeja las ruinas antes de hablar con Mara."
			if r.claimed.has("mara"):
				return "El contacto ya quedó registrado."
			r.claimed.append("mara")
			if state.campaign.mara:
				return "Mara dejó un mensaje: nos vemos en la botica del pueblo."
			r.mara_contact = true
			return "Mara regresará contigo si vuelves por retirada o victoria. Si caes, seguirá refugiada aquí."
		"alijo":
			if r.node != "N5" or r.claimed.has("alijo"):
				return "No queda alijo por recoger aquí."
			r.claimed.append("alijo")
			r.bag.wood += 2
			r.bag.ore += 2
			_offer(r, "R2")
			return "Alijo: +2 madera y +2 mineral. Elige una mejora antes del jefe."
	return "No hay nada que resolver con ese objetivo."

static func _offer(r: Dictionary, id: String) -> void:
	if r.claimed.has(id):
		return
	if not r.offers.has(id):
		if id == "W1":
			r.offers[id] = ["power", "tactical"]
		else:
			var rng := RandomNumberGenerator.new()
			rng.seed = int(r.seed) + (101 if id == "R1" else (303 if id == "E1" else 202))
			var own: Array = []
			var common: Array = []
			for key in UPGRADES:
				if r.upgrades.has(key):
					continue
				if UPGRADES[key]["class"] == r["class"]:
					own.append(key)
				elif UPGRADES[key]["class"] == "common":
					common.append(key)
			var options: Array = []
			for _i in range(mini(2, own.size())):
				var index := rng.randi_range(0, own.size() - 1)
				options.append(own.pop_at(index))
			if not common.is_empty():
				options.append(common[rng.randi_range(0, common.size() - 1)])
			r.offers[id] = options
	r.pending_offer = id

static func _pattern(b: Dictionary) -> String:
	if int(b.get("variant",0)) == 1:
		var patterns := {"slime":["guard","hit","prepare"],"wolf":["heavy","prepare","hit"],"bat":["drain","prepare","hit"],"veteran":["heavy","guard","hit"]}
		if patterns.has(b.enemy): return patterns[b.enemy][int(b.turn)%3]
	if b.enemy == "guardian" and b.phase == 1:
		return ["heavy", "hit", "prepare"][int(b.phase_turn) % 3]
	if b.enemy == "bat":
		return "drain" if int(b.turn) % 2 == 1 else "hit"
	var step := int(b.turn) % 3
	if step == 1:
		return "guard" if b.enemy in ["veteran", "guardian"] else "prepare"
	return "heavy" if step == 2 else "hit"

static func intention(state: Dictionary) -> String:
	if state.active_run.is_empty() or state.active_run.battle.is_empty():
		return ""
	var b: Dictionary = state.active_run.battle
	var kind := _pattern(b)
	if kind == "prepare":
		return "Preparación: no causa daño este turno."
	if kind == "guard":
		return "Levanta guardia: próximo golpe directo -3. No causa daño este turno."
	var damage: int = ENEMIES[b.enemy].attack * (2 if kind == "heavy" else 1)
	return ("Golpe pesado" if kind == "heavy" else "Mordisco" if kind == "drain" else "Golpe") + " · %d daño base" % damage + (" y drena 2 PM." if kind == "drain" else ".")

static func _direct(b: Dictionary, damage: int) -> int:
	if b.guard:
		damage = maxi(1, damage - 3)
		b.guard = false
	b.hp = maxi(0, b.hp - damage)
	return damage

static func _act(state: Dictionary, action: String) -> String:
	var r: Dictionary = state.active_run
	if r.battle.is_empty():
		return "No hay combate activo."
	var b: Dictionary = r.battle
	var enemy: Dictionary = ENEMIES[b.enemy]
	var s := stats(r)
	var text := ""
	match action:
		"attack":
			var damage: int = s.attack + (3 if b.prepared else 0)
			b.prepared = false
			var critical := false
			if r["class"] == "assassin":
				b.focus += 1
				if b.focus >= s.critical_interval:
					critical = true
					b.focus = 0
					damage = int(floor(damage * s.critical_multiplier))
			damage = _direct(b, maxi(1, damage - int(enemy.defense)))
			text = ("¡Crítico! " if critical else "") + "Ataque: %d de daño." % damage
		"magic":
			if r.mp < s.magic_cost:
				return "Necesitas %d PM para Chispa." % s.magic_cost
			r.mp -= s.magic_cost
			text = "Chispa: %d de daño directo." % _direct(b, s.magic)
			if r["class"] == "mage":
				b.burn_turns = maxi(b.burn_turns, s.burn_duration)
				text += " Aplicas quemadura."
		"defend":
			r.mp = mini(r.max_mp, r.mp + int(s.guard_mp))
			if r.upgrades.has("G02"):
				b.prepared = true
			text = "Te proteges y recuperas hasta %d PM." % s.guard_mp
		"potion":
			if r.potions <= 0:
				return "No quedan pociones."
			if r.hp >= 38:
				return "Ya tienes toda la vida."
			r.potions -= 1
			r.hp = mini(38, r.hp + int(s.potion_heal))
			text = "Poción: recuperas hasta %d PV." % s.potion_heal
	if b.burn_turns > 0 and b.hp > 0:
		b.hp = maxi(0, b.hp - int(s.burn_damage))
		b.burn_turns -= 1
		text += " Quemadura: %d." % s.burn_damage
	if b.hp <= 0:
		return _win(state, text)
	var kind := _pattern(b)
	if b.enemy == "guardian" and b.phase == 0 and b.hp <= int(b.max_hp) / 2:
		b.phase = 1
		b.phase_turn = 0
		kind = "transition"
	if kind in ["prepare", "guard", "transition"]:
		if kind == "guard":
			b.guard = true
		text += " " + ("¡Cambio de fase! El guardián prepara su siguiente golpe pesado." if kind == "transition" else "El enemigo levanta guardia." if kind == "guard" else "El enemigo se prepara sin atacar.")
	else:
		var incoming: int = maxi(1, int(enemy.attack) * (2 if kind == "heavy" else 1) - 2)
		if action == "defend":
			incoming = maxi(1, int(incoming * 0.25))
		elif action == "attack" and r.upgrades.has("A02"):
			incoming = maxi(1, incoming - 2)
		r.hp = maxi(0, r.hp - incoming)
		text += " Recibes %d de daño." % incoming
		if kind == "drain":
			r.mp = maxi(0, r.mp - 2)
			text += " Pierdes hasta 2 PM."
		if action == "defend" and r["class"] == "guardian":
			b.hp = maxi(0, b.hp - int(s.reflect))
			text += " Devuelves %d." % s.reflect
	b.turn += 1
	if b.phase == 1 and kind != "transition":
		b.phase_turn += 1
	if r.hp <= 0:
		return text + " " + _finish(state, "lost")
	if b.hp <= 0:
		return _win(state, text)
	b.message = text
	return text

static func _win(state: Dictionary, text: String) -> String:
	var r: Dictionary = state.active_run
	var node: String = r.node
	if r.upgrades.has("C01"):
		r.hp = mini(38, r.hp + 2)
	r.battle = {}
	if r.cleared.has(node):
		return text
	r.cleared.append(node)
	match node:
		"N1":
			r.bag.wood += 2
			_offer(r, "R1")
		"N2B":
			r.bag.ore += 2
		"N4A":
			r.bag.wood += 2
			r.bag.ore += 2
		"N4B":
			r.bag.wood += 2
			r.bag.ore += 4
			_offer(r, "W1")
		"N6":
			r.bag.wood += 2
			r.bag.ore += 2
			return text + " " + _finish(state, "won")
	return text + " Victoria. Materiales añadidos a la mochila en riesgo."

static func _finish(state: Dictionary, outcome: String) -> String:
	if state.active_run.is_empty():
		return "La expedición ya se resolvió."
	var r: Dictionary = state.active_run
	var c: Dictionary = state.campaign
	var keep := outcome != "lost"
	var traveler: bool = keep and r.get("traveler",false)
	if traveler:
		r.bag.wood += 3
		r.bag.ore += 2
	var rescued: bool = keep and r.mara_contact and not c.mara
	var boss: bool = outcome == "won" and not c.boss
	state.last_result = {"id": r.id, "outcome": outcome, "wood": int(r.bag.wood) if keep else 0,
		"ore": int(r.bag.ore) if keep else 0, "lost_wood": 0 if keep else int(r.bag.wood),
		"lost_ore": 0 if keep else int(r.bag.ore), "mara": rescued, "boss": boss, "traveler": traveler, "ack": false}
	if keep:
		c.wood += int(r.bag.wood)
		c.ore += int(r.bag.ore)
		c.mara = c.mara or r.mara_contact
		c.boss = c.boss or outcome == "won"
	state.active_run = {}
	return "Has caído. Pierdes todos los materiales transportados; el almacén queda intacto." if not keep else "Regresas al pueblo con todos los materiales de la mochila."

static func encounter_name(run: Dictionary, node: String) -> String:
	var id: String = NODES[node].enemy
	if id.is_empty(): return ""
	if int(run.get("variation",{}).get("encounters",{}).get(node,0)) == 1:
		return {"slime":"Slime acorazado", "wolf":"Lobo impetuoso", "bat":"Murciélago arcano", "veteran":"Veterano agresivo"}.get(id,ENEMIES[id].name)
	return ENEMIES[id].name

static func event_name(run: Dictionary) -> String:
	return {"merchant":"Mercader extraviado", "altar":"Altar del bosque", "traveler":"Viajero perdido"}.get(run.get("variation",{}).get("event",""),"")

static func _event(r: Dictionary, choice: String) -> String:
	if r.node != "N3" or not r.battle.is_empty() or not r.pending_offer.is_empty() or r.get("event_claimed",true): return "Este evento ya se resolvió o no está disponible."
	if choice == "leave":
		r.event_claimed = true
		return "Decides seguir tu camino."
	var kind: String = r.variation.event
	match kind:
		"merchant":
			if not choice in ["wood","ore"]: return "Oferta desconocida."
			if r.potions >= 3: return "Ya llevas el máximo de 3 suministros."
			if r.bag[choice] < 2: return "Necesitas 2 unidades de ese material en tu mochila."
			r.bag[choice] -= 2
			r.potions += 1
			r.event_claimed = true
			return "Intercambias materiales por un suministro de tu kit."
		"altar":
			if choice != "accept" or r.hp <= 8: return "Necesitas más de 8 PV. El sacrificio nunca puede matarte."
			_offer(r,"E1")
			return "Elige una mejora. Solo pagarás 8 PV si aceptas una; rechazar no cuesta vida."
		"traveler":
			if choice != "help" or r.potions < 1: return "Ayudar requiere un suministro."
			r.potions -= 1
			r.traveler = true
			r.event_claimed = true
			return "El viajero te acompaña. Si regresas a salvo, recibes 3 madera y 2 mineral; si caes, no hay recompensa."
	return "Evento desconocido."
