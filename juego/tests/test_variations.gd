extends SceneTree
const R = preload("res://scripts/expedition_rules.gd")
const S = preload("res://scripts/expedition_store.gd")
var checks := 0
var failures := 0
func check(ok: bool) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("Variation check %d" % checks)
func camp(kind: String) -> Dictionary:
	var s := R.fresh()
	R.command(s,"patio")
	R.command(s,"start")
	var r: Dictionary = s.active_run
	r.node = "N3"
	r.visited = ["N0","N1","N2A","N3"]
	r.cleared = r.visited.duplicate()
	r.bag = {"wood":4,"ore":2}
	r.variation.event = kind
	return s
func _initialize() -> void:
	call_deferred("run")
func run() -> void:
	var seen := {}
	for i in range(80):
		var s := camp("merchant")
		seen[str(s.active_run.variation.encounters)] = true
		var copy := S.parse_text(JSON.stringify(s))
		check(copy == s)
	check(seen.size()>1)
	var s := camp("merchant")
	R.command(s,"event","wood")
	check(s.active_run.bag.wood==2 and s.active_run.potions==3)
	R.command(s,"event","ore")
	check(s.active_run.bag.ore==2 and s.active_run.potions==3)
	s = camp("altar")
	R.command(s,"event","accept")
	check(s.active_run.hp==38 and s.active_run.pending_offer=="E1" and S.valid(s))
	var copy := S.parse_text(JSON.stringify(s))
	check(R.offer_options(copy.active_run)==R.offer_options(s.active_run))
	R.command(s,"choose",R.offer_options(s.active_run)[0])
	check(s.active_run.hp==30 and s.active_run.event_claimed and S.valid(s))
	R.command(s,"event","accept")
	check(s.active_run.hp==30 and s.active_run.pending_offer.is_empty())
	s=camp("altar")
	R.command(s,"event","accept")
	R.command(s,"skip")
	check(s.active_run.hp==38 and s.active_run.event_claimed)
	s=camp("altar")
	s.active_run.hp=8
	R.command(s,"event","accept")
	check(s.active_run.hp==8 and s.active_run.pending_offer.is_empty())
	for outcome in ["retired","lost"]:
		s=camp("traveler")
		R.command(s,"event","help")
		check(s.active_run.potions==1 and s.active_run.traveler)
		R._finish(s,outcome)
		check(S.valid(s))
		check(s.campaign.wood==(7 if outcome=="retired" else 0) and s.campaign.ore==(4 if outcome=="retired" else 0))
		s= S.parse_text(JSON.stringify(s))
		R.command(s,"retreat")
		check(s.campaign.wood==(7 if outcome=="retired" else 0))
	s=camp("merchant")
	s.active_run.erase("variation")
	s.active_run.erase("event_claimed")
	s.active_run.erase("traveler")
	check(S.valid(s) and S.parse_text(JSON.stringify(s))==s)
	for node in ["N1","N2B","N4A","N4B"]:
		s=camp("altar")
		s.active_run.node=node
		s.active_run.cleared=[]
		s.active_run.variation.encounters[node]=1
		R.command(s,"interact","enemy")
		check(s.active_run.battle.variant==1)
		check(not R.intention(s).is_empty())
	print("VARIATIONS: %d checks, %d failures" % [checks,failures])
	quit(1 if failures else 0)
