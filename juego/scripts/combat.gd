class_name ValleyCombat
extends RefCounted

static func create(enemy: EnemyDefinition, instance_id: String) -> Dictionary:
	return {"enemy": enemy.id, "instance": instance_id, "hp": enemy.max_hp,
		"turn": 0, "status": "fighting", "message": "Elige tu respuesta. El maná se recupera al defender."}

static func intention(battle: Dictionary, enemy: EnemyDefinition) -> String:
	if int(battle.turn) % 3 == 2:
		return "¡Golpe pesado! Infligirá %d de daño base. Defender reduce mucho el impacto." % (enemy.attack * 2)
	return "Ataque normal · %d de daño base." % enemy.attack

static func act(state: Dictionary, action: String, enemy: EnemyDefinition) -> String:
	var b: Dictionary = state.battle
	if b.is_empty() or b.status != "fighting":
		return ""
	var attack: int = 7 + (5 if state.flags.sword else 0)
	var message := ""
	match action:
		"attack":
			var damage := maxi(1, attack - enemy.defense)
			b.hp -= damage
			message = "Tu ataque causa %d de daño." % damage
		"magic":
			if state.mp < 4:
				b.message = "Necesitas 4 PM. Defender recupera 3."
				return b.message
			state.mp -= 4
			b.hp -= 13
			message = "Chispa atraviesa la armadura: 13 de daño."
		"defend":
			state.mp = mini(12, state.mp + 3)
			message = "Te proteges y recuperas 3 PM."
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
	if b.hp <= 0:
		b.hp = 0
		b.status = "won"
		if not state.defeated.has(b.instance):
			state.defeated.append(b.instance)
			state.resources.gold += enemy.gold
			if b.instance == "forest_wolf":
				state.flags.mine_open = true
			if enemy.boss:
				state.flags.boss_defeated = true
		b.message = message + " Victoria: +%d monedas." % enemy.gold
		return b.message
	var incoming: int = enemy.attack * (2 if int(b.turn) % 3 == 2 else 1)
	incoming = maxi(1, incoming - 2)
	if action == "defend":
		incoming = maxi(1, int(incoming * 0.25))
	state.hp = maxi(0, state.hp - incoming)
	b.turn += 1
	if state.hp == 0:
		b.status = "lost"
		state.resources.gold = maxi(0, state.resources.gold - 5)
		message += " Has caído. Pierdes hasta 5 monedas; tus materiales están a salvo."
	else:
		message += " Recibes %d de daño." % incoming
	b.message = message
	return message
