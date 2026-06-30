extends Node2D
## Press F1 to toggle. Draws all collision rects, elevation/water zones, dens and
## spawns over the map art so we can see how the invisible layout lines up with
## the background and nudge positions.

var enabled := false

func _ready() -> void:
	z_index = 500

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_F1 or event.physical_keycode == KEY_F1:
			enabled = not enabled
			queue_redraw()

func _process(_delta: float) -> void:
	if enabled:
		queue_redraw()

func _draw() -> void:
	if not enabled:
		return
	var scene := get_tree().current_scene
	if scene != null:
		_scan(scene)

func _scan(n: Node) -> void:
	for c in n.get_children():
		if c is CollisionShape2D and c.shape is RectangleShape2D and c.get_parent() is StaticBody2D:
			var sz: Vector2 = (c.shape as RectangleShape2D).size
			var body := c.get_parent() as StaticBody2D
			var col := Color(1, 0.85, 0.2, 0.9) if (body.collision_layer & 16) != 0 else Color(1, 0.3, 0.3, 0.9)
			draw_rect(Rect2(c.global_position - sz * 0.5, sz), col, false, 4.0)
		elif c is Node2D and c.is_in_group("elevation_zones"):
			var ez: Vector2 = c.size
			draw_rect(Rect2(c.global_position - ez * 0.5, ez), Color(0.3, 0.6, 1, 0.85), false, 4.0)
		elif c is Node2D and c.is_in_group("water_zones"):
			var wz: Vector2 = c.size
			draw_rect(Rect2(c.global_position - wz * 0.5, wz), Color(0.2, 0.9, 1, 0.95), false, 4.0)
		if c is Node2D and c.is_in_group("den_zones"):
			draw_circle(c.global_position, 120.0, Color(1, 0.6, 0.2, 0.25))
		if c is Node2D and (c.is_in_group("tortoise_spawns") or c.is_in_group("rabbit_spawns")):
			draw_circle(c.global_position, 22.0, Color(0.3, 1, 0.4, 0.85))
		_scan(c)
