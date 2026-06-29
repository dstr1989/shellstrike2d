extends Node
class_name BotAI
## Simple state-machine AI for MVP bots-only testing. No navmesh: assumes a
## roughly open placeholder map. Drives the parent Unit via its AI control
## surface (set_desired_move / set_desired_aim / set_firing / set_interacting).

enum State { SEEK_TARGET, ENGAGE, GO_TO_DEN, PLANT, DEFUSE }

@export var vision_range: float = 650.0
@export var engage_range: float = 550.0
@export var aim_jitter_degrees: float = 4.0

var _unit: Unit
var _state: State = State.SEEK_TARGET
var _target_enemy: Unit = null
var _wander_target: Vector2 = Vector2.ZERO
var _repath_timer: float = 0.0

func _ready() -> void:
	_unit = get_parent()
	_pick_new_wander_target()

func _physics_process(delta: float) -> void:
	if not is_instance_valid(_unit) or not _unit.health.is_alive():
		return

	_repath_timer -= delta
	_target_enemy = _find_nearest_enemy()

	if _target_enemy:
		_state = State.ENGAGE
	elif _unit.team == Global.Team.RABBIT and _unit.is_carrying_charge():
		_state = State.GO_TO_DEN
	elif _unit.team == Global.Team.TORTOISE and GameManager.charge_planted:
		_state = State.DEFUSE
	else:
		_state = State.SEEK_TARGET

	match _state:
		State.ENGAGE:
			_do_engage()
		State.GO_TO_DEN:
			_do_go_to_den()
		State.DEFUSE:
			_do_go_to_den(true)
		_:
			_do_wander()

func _find_nearest_enemy() -> Unit:
	var best: Unit = null
	var best_dist := vision_range
	for node in get_tree().get_nodes_in_group("units"):
		var other := node as Unit
		if other == null or other == _unit or other.team == _unit.team:
			continue
		if not other.health.is_alive():
			continue
		var dist := _unit.global_position.distance_to(other.global_position)
		if dist < best_dist:
			best_dist = dist
			best = other
	return best

func _do_engage() -> void:
	var to_enemy := _target_enemy.global_position - _unit.global_position
	var dist := to_enemy.length()
	var jitter := deg_to_rad(randf_range(-aim_jitter_degrees, aim_jitter_degrees))
	_unit.set_desired_aim(to_enemy.normalized().rotated(jitter))
	_unit.set_firing(dist <= engage_range)
	if dist > engage_range * 0.7:
		_unit.set_desired_move(to_enemy.normalized())
	elif dist < engage_range * 0.4:
		_unit.set_desired_move(-to_enemy.normalized())
	else:
		_unit.set_desired_move(Vector2.ZERO)
	_unit.set_interacting(false)

func _do_go_to_den(defuse_when_close: bool = false) -> void:
	var charge := get_tree().get_first_node_in_group("carrot_charge")
	var dens := get_tree().get_nodes_in_group("den_zones")
	var target_pos: Vector2
	if defuse_when_close and charge:
		target_pos = charge.global_position
	elif dens.size() > 0:
		target_pos = dens[randi() % dens.size()].global_position
	else:
		target_pos = _unit.global_position
	var to_target := target_pos - _unit.global_position
	var dist := to_target.length()
	_unit.set_desired_aim(to_target.normalized() if dist > 1.0 else Vector2.RIGHT)
	if dist > 40.0:
		_unit.set_desired_move(to_target.normalized())
		_unit.set_interacting(false)
	else:
		_unit.set_desired_move(Vector2.ZERO)
		_unit.set_firing(false)
		_unit.set_interacting(true)

func _do_wander() -> void:
	if _repath_timer <= 0.0 or _unit.global_position.distance_to(_wander_target) < 30.0:
		_pick_new_wander_target()
	var to_target := _wander_target - _unit.global_position
	_unit.set_desired_move(to_target.normalized())
	_unit.set_desired_aim(to_target.normalized() if to_target.length() > 1.0 else Vector2.RIGHT)
	_unit.set_firing(false)
	_unit.set_interacting(false)

func _pick_new_wander_target() -> void:
	_repath_timer = randf_range(2.0, 4.5)
	var spawn_group := "tortoise_spawns" if _unit.team == Global.Team.TORTOISE else "rabbit_spawns"
	var spawns := get_tree().get_nodes_in_group(spawn_group)
	var dens := get_tree().get_nodes_in_group("den_zones")
	var pool := dens if dens.size() > 0 else spawns
	if pool.size() > 0:
		_wander_target = pool[randi() % pool.size()].global_position + Vector2(randf_range(-80, 80), randf_range(-80, 80))
	else:
		_wander_target = _unit.global_position
