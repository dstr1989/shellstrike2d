extends Node
## Autoload singleton: shared input state written by on-screen touch controls
## (VirtualJoystick / aim joystick / fire button) and read by the locally
## controlled Unit. Falls back to keyboard/mouse automatically when the touch
## sticks report zero (handy for testing in the Godot editor on desktop).

var move_vector: Vector2 = Vector2.ZERO
var aim_vector: Vector2 = Vector2.ZERO
var fire_held: bool = false
var interact_pressed: bool = false

func get_move_vector() -> Vector2:
	if move_vector.length() > 0.05:
		return move_vector
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")

func get_aim_vector(unit_global_pos: Vector2) -> Vector2:
	if aim_vector.length() > 0.05:
		return aim_vector
	var mouse_pos := unit_global_pos
	var viewport := Engine.get_main_loop()
	if viewport is SceneTree and (viewport as SceneTree).root:
		mouse_pos = (viewport as SceneTree).root.get_mouse_position()
	return (mouse_pos - unit_global_pos).normalized()

func is_firing() -> bool:
	return fire_held or Input.is_action_pressed("fire")

func is_interacting() -> bool:
	if interact_pressed:
		return true
	return Input.is_action_pressed("plant_defuse")
