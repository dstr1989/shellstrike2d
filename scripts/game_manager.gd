extends Node
## Autoload singleton: round/match state machine for Shellstrike2D.
## MVP scope: single map, bots-only, no buy phase (configurable via Global.BUY_PHASE_SECONDS).

signal phase_changed(phase: int)
signal round_time_changed(seconds_left: float)
signal round_ended(reason: int, winner: int)
signal score_changed(tortoise_score: int, rabbit_score: int)

var phase: int = Global.RoundPhase.WARMUP
var round_time_left: float = 0.0
var tortoise_score: int = 0
var rabbit_score: int = 0
var charge_planted: bool = false

var _actors: Array[Node] = [] # everything with a Team + HealthComponent (players + bots)

func register_actor(actor: Node) -> void:
	if not _actors.has(actor):
		_actors.append(actor)

func unregister_actor(actor: Node) -> void:
	_actors.erase(actor)

func start_match() -> void:
	tortoise_score = 0
	rabbit_score = 0
	score_changed.emit(tortoise_score, rabbit_score)
	start_round()

func start_round() -> void:
	charge_planted = false
	_set_phase(Global.RoundPhase.ACTION if Global.BUY_PHASE_SECONDS <= 0.0 else Global.RoundPhase.BUY)
	round_time_left = Global.BUY_PHASE_SECONDS if phase == Global.RoundPhase.BUY else Global.ROUND_SECONDS
	get_tree().call_group("respawnable", "respawn_for_new_round")

func _process(delta: float) -> void:
	if phase in [Global.RoundPhase.BUY, Global.RoundPhase.ACTION, Global.RoundPhase.PLANTED]:
		round_time_left = max(0.0, round_time_left - delta)
		round_time_changed.emit(round_time_left)
		_check_timers()

func _check_timers() -> void:
	if phase == Global.RoundPhase.BUY and round_time_left <= 0.0:
		_set_phase(Global.RoundPhase.ACTION)
		round_time_left = Global.ROUND_SECONDS
		return
	if phase == Global.RoundPhase.ACTION and round_time_left <= 0.0:
		end_round(Global.RoundEndReason.TIME_OUT_NO_PLANT, Global.Team.TORTOISE)
		return
	if phase == Global.RoundPhase.PLANTED and round_time_left <= 0.0:
		end_round(Global.RoundEndReason.CHARGE_EXPLODED, Global.Team.RABBIT)
		return

func notify_charge_planted() -> void:
	charge_planted = true
	_set_phase(Global.RoundPhase.PLANTED)
	round_time_left = Global.PLANT_FUSE_SECONDS

func notify_charge_defused() -> void:
	end_round(Global.RoundEndReason.CHARGE_DEFUSED, Global.Team.TORTOISE)

func notify_actor_died(actor: Node) -> void:
	if not _actors.has(actor):
		return
	_check_team_elimination()

func _check_team_elimination() -> void:
	if phase == Global.RoundPhase.ROUND_END:
		return
	var tortoises_alive := 0
	var rabbits_alive := 0
	for actor in _actors:
		if not is_instance_valid(actor):
			continue
		var hp: HealthComponent = actor.get_node_or_null("HealthComponent")
		if hp == null or not hp.is_alive():
			continue
		if actor.team == Global.Team.TORTOISE:
			tortoises_alive += 1
		elif actor.team == Global.Team.RABBIT:
			rabbits_alive += 1
	if tortoises_alive == 0 and rabbits_alive > 0:
		end_round(Global.RoundEndReason.TEAM_ELIMINATED, Global.Team.RABBIT)
	elif rabbits_alive == 0 and tortoises_alive > 0 and not charge_planted:
		end_round(Global.RoundEndReason.TEAM_ELIMINATED, Global.Team.TORTOISE)

func end_round(reason: int, winner: int) -> void:
	if phase == Global.RoundPhase.ROUND_END:
		return
	_set_phase(Global.RoundPhase.ROUND_END)
	if winner == Global.Team.TORTOISE:
		tortoise_score += 1
	elif winner == Global.Team.RABBIT:
		rabbit_score += 1
	score_changed.emit(tortoise_score, rabbit_score)
	round_ended.emit(reason, winner)
	await get_tree().create_timer(3.0).timeout
	start_round()

func _set_phase(new_phase: int) -> void:
	phase = new_phase
	phase_changed.emit(phase)
