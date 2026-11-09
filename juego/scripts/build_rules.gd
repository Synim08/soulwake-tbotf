class_name ValleyBuildRules
extends RefCounted

const STYLES := {
	"guardian": {"name": "Guerrero", "description": "Defender devuelve 3 de daño al enemigo.", "talents": ["reprisal", "renewal"]},
	"mage": {"name": "Mago", "description": "Chispa quema: 2 de daño durante 2 acciones, incluida la actual.", "talents": ["embers", "channeling"]},
	"ranger": {"name": "Explorador", "description": "Cada tercer ataque es crítico. El contador se muestra; no depende del azar.", "talents": ["precision", "mobility"]}}
const TALENTS := {
	"reprisal": {"name": "Represalia", "description": "Al defender, devuelves 6 de daño en lugar de 3."},
	"renewal": {"name": "Segundo aliento", "description": "Al defender, recuperas hasta 3 PV además del maná."},
	"embers": {"name": "Ascua persistente", "description": "La quemadura de Chispa dura 1 turno adicional."},
	"channeling": {"name": "Canalización", "description": "Chispa cuesta 3 PM en lugar de 4."},
	"precision": {"name": "Puntería", "description": "Cada segundo ataque es crítico en lugar del tercero."},
	"mobility": {"name": "Movilidad", "description": "Cuando atacas, recibes 2 puntos menos de daño ese turno."}}
const GEAR := {
	"training_blade": preload("res://data/gear/training_blade.tres"),
	"valley_blade": preload("res://data/gear/valley_blade.tres"),
	"ember_staff": preload("res://data/gear/ember_staff.tres"),
	"trail_bow": preload("res://data/gear/trail_bow.tres"),
	"none": preload("res://data/gear/none.tres"),
	"sap_seal": preload("res://data/gear/sap_seal.tres"),
	"ember_charm": preload("res://data/gear/ember_charm.tres")}
const WEAPONS := ["training_blade", "valley_blade", "ember_staff", "trail_bow"]
const RELICS := ["none", "sap_seal", "ember_charm"]

static func defaults(forged: bool = false) -> Dictionary:
	return {
		"guardian": {"talent": "reprisal", "weapon": "valley_blade" if forged else "training_blade", "relic": "none"},
		"mage": {"talent": "embers", "weapon": "ember_staff" if forged else "training_blade", "relic": "none"},
		"ranger": {"talent": "precision", "weapon": "trail_bow" if forged else "training_blade", "relic": "none"}}

static func selected(state: Dictionary) -> Dictionary:
	return state.loadouts[state.active_style]

static func stats(state: Dictionary) -> Dictionary:
	var loadout := selected(state)
	var weapon: Resource = GEAR[loadout.weapon]
	var relic: Resource = GEAR[loadout.relic]
	return {"attack": 7 + weapon.attack_bonus, "magic": 13 + weapon.magic_bonus,
		"magic_cost": 3 if state.active_style == "mage" and loadout.talent == "channeling" else 4,
		"guard_mp": 3 + relic.mana_on_guard,
		"burn_bonus": weapon.burn_bonus + relic.burn_bonus,
		"critical_multiplier": weapon.critical_multiplier,
		"critical_interval": 2 if state.active_style == "ranger" and loadout.talent == "precision" else 3}

static func valid_loadouts(state: Dictionary) -> bool:
	if not state.get("active_style") in STYLES or not state.get("loadouts") is Dictionary:
		return false
	for style in STYLES:
		if not state.loadouts.has(style) or not state.loadouts[style] is Dictionary:
			return false
		var l: Dictionary = state.loadouts[style]
		if not l.get("talent") in STYLES[style].talents or not l.get("weapon") in WEAPONS or not l.get("relic") in RELICS:
			return false
		if not state.flags.sword and l.weapon != "training_blade":
			return false
		if not state.flags.boss_defeated and l.relic != "none":
			return false
	return true
