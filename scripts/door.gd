extends StaticBody2D
class_name Door
## Sliding door: opens (collision off + panel slides aside) while any unit is in
## its detection area, closes when empty. Slide direction is the door's local up,
## so set the node's rotation to orient it.

@export var slide: Vector2 = Vector2(0, -86)
@export var open_speed: float = 0.22

@onready var shape: CollisionShape2D = $C
@onready var sprite: Sprite2D = $Sprite
@onready var detect: Area2D = $Detect

var _open: bool = false
var _closed_pos: Vector2

func _ready() -> void:
	_closed_pos = sprite.position
	detect.body_entered.connect(_on_changed)
	detect.body_exited.connect(_on_changed)

func _on_changed(_b: Node) -> void:
	var any := false
	for b in detect.get_overlapping_bodies():
		if b is Unit:
			any = true
			break
	if any == _open:
		return
	_open = any
	shape.set_deferred("disabled", any)
	var tw := create_tween()
	tw.tween_property(sprite, "position", _closed_pos + (slide if any else Vector2.ZERO), open_speed)
