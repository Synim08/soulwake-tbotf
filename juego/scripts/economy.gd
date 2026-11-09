class_name ValleyEconomy
extends RefCounted

const OFFLINE_LIMIT := 8 * 60 * 60
const CAP := 9999

static func advance(state: Dictionary, seconds: float) -> Dictionary:
	var elapsed := clampf(seconds, 0.0, OFFLINE_LIMIT)
	var before: Dictionary = state.resources.duplicate()
	var total: float = float(state.production.remainder) + elapsed
	var ticks := int(floor(total))
	state.production.remainder = total - ticks
	for _tick in range(ticks):
		if state.workers.mara and state.flags.mine_open:
			state.production.mine += 1
			if state.production.mine >= 5:
				state.production.mine = 0
				state.resources.ore = mini(CAP, state.resources.ore + 1)
		if state.workers.ivo and state.flags.forge_repaired:
			if state.resources.ore >= 2 and state.resources.ingot < CAP:
				state.production.forge += 1
				if state.production.forge >= 8:
					state.production.forge = 0
					state.resources.ore -= 2
					state.resources.ingot += 1
			else:
				state.production.forge = 0
	return {"ore": state.resources.ore - before.ore,
		"ingot": state.resources.ingot - before.ingot, "seconds": elapsed}
