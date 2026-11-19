extends RefCounted
## Reglas de la prueba en tiempo real. El escenario resuelve impactos y persistencia.

const HEALTH_MAX := 38
const STAMINA_MAX := 100.0
const LIGHT_COST := 25.0
const HEAVY_COST := 50.0
const POTION_MAX := 1
const HITS_PER_CHARGE := 4
const POTION_HEAL := 18
const GUARD_BREAK_TIME := 0.62
const HURT_PROTECTION := 0.45
const STAMINA_RECOVERY := 30.0
const STAMINA_DELAY := 0.55
const BLOCK_DAMAGE_RATIO := 0.25

var hp: int = HEALTH_MAX
var stamina: float = STAMINA_MAX
var potions: int = POTION_MAX
var charge: int = 0
var defeated: Array[int] = []
var status: String = "active"
var guard_break: float = 0.0
var invulnerable: float = 0.0
var message: String = ""

var _stamina_delay := 0.0

func spend_attack(heavy: bool) -> bool:
	if status != "active" or guard_break > 0.0:
		return false
	var cost := HEAVY_COST if heavy else LIGHT_COST
	if stamina < cost:
		message = "Estamina insuficiente."
		return false
	_spend_stamina(cost)
	return true

func tick(delta: float, guarding: bool = false) -> void:
	if status != "active" or delta <= 0.0:
		return
	var recovery_time := maxf(0.0, delta - maxf(_stamina_delay, guard_break))
	_stamina_delay = maxf(0.0, _stamina_delay - delta)
	guard_break = maxf(0.0, guard_break - delta)
	invulnerable = maxf(0.0, invulnerable - delta)
	if not guarding:
		stamina = minf(STAMINA_MAX, stamina + recovery_time * STAMINA_RECOVERY)

func can_block() -> bool:
	return status == "active" and guard_break <= 0.0 and stamina > 0.0

func receive_hit(damage: int, block_cost: float, blocking: bool) -> Dictionary:
	if status != "active" or invulnerable > 0.0 or damage <= 0:
		return {"damage": 0, "blocked": false, "broken": false, "ignored": true}

	var blocked := false
	var broken := false
	var incoming := damage
	if blocking and can_block():
		if stamina >= block_cost:
			blocked = true
			_spend_stamina(block_cost)
			incoming = maxi(1, int(ceil(damage * BLOCK_DAMAGE_RATIO)))
		else:
			broken = true
			_spend_stamina(stamina)
			guard_break = GUARD_BREAK_TIME

	var applied := mini(hp, incoming)
	hp -= applied
	invulnerable = HURT_PROTECTION
	if hp == 0:
		status = "lost"
		message = "Has caído."
	elif broken:
		message = "¡Guardia rota!"
	elif blocked:
		message = "Golpe bloqueado."
	else:
		message = "Recibes %d de daño." % applied
	return {"damage": applied, "blocked": blocked, "broken": broken, "ignored": false}

func register_effective_attack() -> void:
	if status != "active" or potions >= POTION_MAX:
		return
	charge += 1
	if charge >= HITS_PER_CHARGE:
		potions += 1
		charge = 0
		message = "Poción recuperada."

func drink() -> bool:
	if status != "active":
		return false
	if potions <= 0:
		message = "Acierta golpes para recuperar la poción."
		return false
	if hp >= HEALTH_MAX:
		message = "Ya tienes toda la vida."
		return false
	potions -= 1
	var healed := mini(POTION_HEAL, HEALTH_MAX - hp)
	hp += healed
	message = "Poción: recuperas %d PV." % healed
	return true

func mark_defeated(index: int, total: int) -> void:
	if status != "active" or index < 0 or index >= total or defeated.has(index):
		return
	defeated.append(index)
	if defeated.size() == total:
		status = "won"
		message = "Claro despejado."

func snapshot() -> Dictionary:
	return {
		"hp": hp,
		"stamina": stamina,
		"potions": potions,
		"charge": charge,
		"defeated": defeated.duplicate(),
		"status": status,
	}

func restore(data: Dictionary, enemy_total: int) -> bool:
	if enemy_total <= 0:
		return false
	if not _whole_in_range(data.get("hp"), 0, HEALTH_MAX):
		return false
	var saved_stamina: Variant = data.get("stamina")
	if not _number_in_range(saved_stamina, 0.0, STAMINA_MAX):
		return false
	if not _whole_in_range(data.get("potions"), 0, POTION_MAX):
		return false
	if not _whole_in_range(data.get("charge"), 0, HITS_PER_CHARGE - 1):
		return false
	if data.potions == POTION_MAX and data.charge > 0:
		return false
	var saved_status: Variant = data.get("status")
	if not saved_status is String or not saved_status in ["active", "won", "lost"]:
		return false
	var saved_defeated: Variant = data.get("defeated")
	if not saved_defeated is Array or saved_defeated.size() > enemy_total:
		return false
	var normalized_defeated: Array[int] = []
	for id in saved_defeated:
		if not _whole_in_range(id, 0, enemy_total - 1) or normalized_defeated.has(int(id)):
			return false
		normalized_defeated.append(int(id))
	if (saved_status == "lost") != (data.hp == 0):
		return false
	if (saved_status == "won") != (normalized_defeated.size() == enemy_total):
		return false

	hp = int(data.hp)
	stamina = float(saved_stamina)
	potions = int(data.potions)
	charge = int(data.charge)
	defeated = normalized_defeated
	status = saved_status
	guard_break = 0.0
	invulnerable = 0.0
	_stamina_delay = STAMINA_DELAY
	message = ""
	return true

func hud_data(enemy_total: int, player_mode: String) -> Dictionary:
	return {
		"hp": hp,
		"max_hp": HEALTH_MAX,
		"stamina": stamina,
		"max_stamina": STAMINA_MAX,
		"potions": potions,
		"max_potions": POTION_MAX,
		"charge": charge,
		"hits_per_charge": HITS_PER_CHARGE,
		"enemies_alive": maxi(0, enemy_total - defeated.size()),
		"enemy_total": enemy_total,
		"status": status,
		"message": message,
		"player_mode": player_mode,
	}

func _spend_stamina(cost: float) -> void:
	stamina = maxf(0.0, stamina - cost)
	_stamina_delay = STAMINA_DELAY

static func _number_in_range(value: Variant, low: float, high: float) -> bool:
	if not (value is int or value is float):
		return false
	var number := float(value)
	return number >= low and number <= high

static func _whole_in_range(value: Variant, low: int, high: int) -> bool:
	return _number_in_range(value, low, high) and floorf(float(value)) == float(value)
