extends Node2D
class_name CarrotCharge
## The "Carrot Charge" - Shellstrike2D's bomb equivalent. Rabbits plant it at
## a Den zone; Tortoises must defuse it before the fuse runs out.

signal planted
signal defused
signal exploded

@onready var sprite: Node2D = $Sprite

var _is_planted: bool = false
var _planter: Unit = null
var _plant_progress: float = 0.0
var _defuse_progress: float = 0.0
var _defuser: Unit = null
var _planting_this_frame: bool = false
var _defusing_this_frame: bool = false

func _process(_delta: float) -> void:
	# Decay progress if nobody actively held the action this frame.
	if not _planting_this_frame and _plant_progress > 0.0 and not _is_planted:
		_plant_progress = 0.0
	if not _defusing_this_frame and _defuse_progress > 0.0:
		_defuse_progress = 0.0
		_defuser = null
	_planting_this_frame = false
	_defusing_this_frame = false

func _ready() -> void:
	add_to_group("carrot_charge")
	visible = false
	GameManager.phase_changed.connect(_on_phase_changed)

func _on_phase_changed(phase: int) -> void:
	if phase == Global.RoundPhase.ACTION:
		_reset_for_new_round()

func _reset_for_new_round() -> void:
	_is_planted = false
	_plant_progress = 0.0
	_defuse_progress = 0.0
	_defuser = null
	_planter = null
	visible = false

const PLANT_RANGE := 120.0
const DEFUSE_RANGE := 60.0

func _near_den(pos: Vector2) -> bool:
	for den in get_tree().get_nodes_in_group("den_zones"):
		if pos.distance_to(den.global_position) <= PLANT_RANGE:
			return true
	return false

func can_plant_at(pos: Vector2) -> bool:
	return not _is_planted and GameManager.phase == Global.RoundPhase.ACTION and _near_den(pos)

func can_defuse_at(pos: Vector2) -> bool:
	return _is_planted and GameManager.phase == Global.RoundPhase.PLANTED \
		and pos.distance_to(global_position) <= DEFUSE_RANGE

func try_plant(rabbit: Unit) -> void:
	if _is_planted or GameManager.phase != Global.RoundPhase.ACTION:
		return
	if not rabbit.is_carrying_charge():
		return
	if not _near_den(rabbit.global_position):
		_plant_progress = 0.0
		return
	_planter = rabbit
	_planting_this_frame = true
	_plant_progress += get_physics_process_delta_time()
	if _plant_progress >= Global.PLANT_SECONDS:
		_complete_plant(rabbit)

func _complete_plant(rabbit: Unit) -> void:
	_is_planted = true
	visible = true
	global_position = rabbit.global_position
	rabbit.notify_charge_planted_by_me()
	GameManager.notify_charge_planted()
	planted.emit()

func try_defuse(tortoise: Unit) -> void:
	if not _is_planted or GameManager.phase != Global.RoundPhase.PLANTED:
		return
	if tortoise.global_position.distance_to(global_position) > 48.0:
		_defuse_progress = 0.0
		return
	if _defuser != tortoise:
		_defuser = tortoise
		_defuse_progress = 0.0
	_defusing_this_frame = true
	_defuse_progress += get_physics_process_delta_time()
	if _defuse_progress >= Global.DEFUSE_SECONDS:
		_complete_defuse()

func _complete_defuse() -> void:
	_is_planted = false
	visible = false
	GameManager.notify_charge_defused()
	defused.emit()

func get_plant_fraction() -> float:
	return clamp(_plant_progress / Global.PLANT_SECONDS, 0.0, 1.0)

func get_defuse_fraction() -> float:
	return clamp(_defuse_progress / Global.DEFUSE_SECONDS, 0.0, 1.0)

func is_planted() -> bool:
	return _is_planted
