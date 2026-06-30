extends Node2D
class_name WaterZone
## Rectangular water area (passable, not solid). Units sample it each frame
## (group "water_zones"). Tortoises swim fast here but can't shoot; Rabbits may
## only wade the shallow rim — going into deep water starts drowning.

@export var size: Vector2 = Vector2(400, 300)
@export var shallow_margin: float = 80.0   # rim width that counts as "knee-deep"
@export var debug_draw: bool = false

func _ready() -> void:
	add_to_group("water_zones")
	queue_redraw()

func contains_point(p: Vector2) -> bool:
	var local := to_local(p)
	return absf(local.x) <= size.x * 0.5 and absf(local.y) <= size.y * 0.5

func depth_at(p: Vector2) -> float:
	# Distance from the nearest edge: 0 at the shore, larger toward the centre.
	var local := to_local(p)
	return minf(size.x * 0.5 - absf(local.x), size.y * 0.5 - absf(local.y))

func is_deep(p: Vector2) -> bool:
	return depth_at(p) > shallow_margin

func _draw() -> void:
	if not debug_draw:
		return
	draw_rect(Rect2(-size * 0.5, size), Color(0.2, 0.5, 1.0, 0.2), true)
