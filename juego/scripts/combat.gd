class_name ValleyCombat
extends RefCounted

const Builds = preload("res://scripts/build_rules.gd")

static func create(enemy: EnemyDefinition, instance_id: String) -> Dictionary:
	return {"enemy": enemy.id, "instance": instance_id, "hp": enemy.max_hp,
		"turn": 0, "status": "fighting", "burn_turns": 0, "focus": 0, "practice": false,
		"message": "Elige tu respuesta. El maná se recupera al defender."}

static func intention(battle: Dictionary, enemy: EnemyDefinition) -> String:
	if int(battle.turn) % 3 == 2:
		return "¡Golpe pesado! Infligirá %d de daño base. Defender reduce mucho el impacto." % (enemy.attack * 2)
	return "Ataque normal · %d de daño base." % enemy.attack

static func act(state: Dictionary, action: String, enemy: EnemyDefinition) -> String:
	var b: Dictionary = state.battle
	if b.is_empty() or b.status != "fighting":
		return ""
	var stats := Builds.stats(state)
	var loadout := Builds.selected(state)
	var style: String = state.active_style
	var message := ""
	match action:
		"attack":
			var base: int = stats.attack
			var critical := false
			if style == "ranger":
				b.focus += 1
				if b.focus >= stats.critical_interval:
					critical = true
					b.focus = 0
					base = int(floor(base * stats.critical_multiplier))
			var damage := maxi(1, base - enemy.defense)
			b.hp -= damage
			message = ("¡Crítico! " if critical else "") + "Tu ataque causa %d de daño." % damage
		"magic":
			if state.mp < stats.magic_cost:
				b.message = "Necesitas %d PM. Defender recupera %d." % [stats.magic_cost, stats.guard_mp]
				return b.message
			state.mp -= stats.magic_cost
			b.hp -= stats.magic
			message = "Chispa atraviesa la armadura: %d de daño." % stats.magic
			if style == "mage":
				var duration: int = 2 + stats.burn_bonus + (1 if loadout.talent == "embers" else 0)
				b.burn_turns = maxi(b.burn_turns, duration)
				message += " Aplicas quemadura."
		"defend":
			state.mp = mini(12, state.mp + stats.guard_mp)
			message = "Te proteges y recuperas hasta %d PM." % stats.guard_mp
			if style == "guardian" and loadout.talent == "renewal":
				state.hp = mini(38, state.hp + 3)
				message += " Segundo aliento: hasta 3 PV."
		"potion":
			if state.potions <= 0:
				b.message = "No tienes pociones. Puedes descansar en el pueblo."
				return b.message
			if state.hp >= 38:
				b.message = "Ya tienes toda la vida."
				return b.message
			state.potions -= 1
			state.hp = mini(38, state.hp + 22)
			message = "Recuperas hasta 22 PV."
		"flee":
			b.status = "escaped"
			b.message = "Te retiras a salvo. No has recibido recompensa."
			return b.message
		_:
			return "Acción desconocida."
	if b.burn_turns > 0 and b.hp > 0:
		b.hp -= 2
		b.burn_turns -= 1
		message += " Quemadura: 2 de daño."
	if b.hp <= 0:
		return victory(state, enemy, message)
	var incoming: int = enemy.attack * (2 if int(b.turn) % 3 == 2 else 1)
	incoming = maxi(1, incoming - 2)
	if action == "defend":
		incoming = maxi(1, int(incoming * 0.25))
	elif action == "attack" and style == "ranger" and loadout.talent == "mobility":
		incoming = maxi(1, incoming - 2)
	state.hp = maxi(0, state.hp - incoming)
	b.turn += 1
	message += " Recibes %d de daño." % incoming
	if action == "defend" and style == "guardian":
		var reflected := 6 if loadout.talent == "reprisal" else 3
		b.hp = maxi(0, b.hp - reflected)
		message += " Devuelves %d." % reflected
	if state.hp == 0:
		b.status = "lost"
		if not b.practice:
			state.resources.gold = maxi(0, state.resources.gold - 5)
		message += " Fin del entrenamiento; no pierdes recursos." if b.practice else " Has caído. Pierdes hasta 5 monedas; tus materiales están a salvo."
	elif b.hp <= 0:
		return victory(state, enemy, message)
	b.message = message
	return message

static func victory(state: Dictionary, enemy: EnemyDefinition, message: String) -> String:
	var b: Dictionary = state.battle
	b.hp = 0
	b.status = "won"
	if b.practice:
		b.message = message + " Entrenamiento completado. Sin recompensas ni consumo permanente de suministros."
		return b.message
	if not state.defeated.has(b.instance):
		state.defeated.append(b.instance)
		state.resources.gold += enemy.gold
		if b.instance == "forest_wolf":
			state.flags.mine_open = true
		if enemy.boss:
			state.flags.boss_defeated = true
	b.message = message + " Victoria: +%d monedas." % enemy.gold
	return b.message
