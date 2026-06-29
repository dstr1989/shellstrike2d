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

func try_plant(rabbit: Unit) -> void:
	if _is_planted or GameManager.phase != Global.RoundPhase.ACTION:
		return
	if not rabbit.is_carrying_charge():
		return
	_planter = rabbit
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
