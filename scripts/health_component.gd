extends Node
class_name HealthComponent
## Reusable health/damage/death component, attach as a child node to any actor.

signal damaged(amount: int, current_hp: int, attacker: Node)
signal died(attacker: Node)

@export var max_hp: int = Global.STARTING_HP
var current_hp: int

func _ready() -> void:
	current_hp = max_hp

func is_alive() -> bool:
	return current_hp > 0

func apply_damage(amount: int, attacker: Node = null) -> void:
	if not is_alive():
		return
	current_hp = max(0, current_hp - amount)
	damaged.emit(amount, current_hp, attacker)
	if current_hp == 0:
		died.emit(attacker)

func reset_health() -> void:
	current_hp = max_hp
