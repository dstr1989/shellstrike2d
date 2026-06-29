extends Control
class_name VirtualJoystick
## On-screen analog stick. mode = "move" writes to TouchInput.move_vector,
## mode = "aim" writes to TouchInput.aim_vector and also fires while dragged
## (so right-stick drag = aim + auto-fire, like a twin-stick shooter).

@export_enum("move", "aim") var mode: String = "move"
@export var max_radius: float = 80.0

@onready var base: Control = $Base
@onready var knob: Control = $Base/Knob

var _touch_index: int = -1
var _origin: Vector2 = Vector2.ZERO

func _ready() -> void:
	_origin = base.size / 2.0
	knob.position = _origin

func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed and _touch_index == -1:
			_touch_index = event.index
			_update_knob(event.position)
		elif not event.pressed and event.index == _touch_index:
			_touch_index = -1
			_reset()
	elif event is InputEventScreenDrag and event.index == _touch_index:
		_update_knob(event.position)

func _update_knob(local_pos: Vector2) -> void:
	var offset := local_pos - _origin
	if offset.length() > max_radius:
		offset = offset.normalized() * max_radius
	knob.position = _origin + offset
	var normalized := offset / max_radius
	if mode == "move":
		TouchInput.move_vector = normalized
	else:
		TouchInput.aim_vector = normalized
		TouchInput.fire_held = normalized.length() > 0.3

func _reset() -> void:
	knob.position = _origin
	if mode == "move":
		TouchInput.move_vector = Vector2.ZERO
	else:
		TouchInput.aim_vector = Vector2.ZERO
		TouchInput.fire_held = false
