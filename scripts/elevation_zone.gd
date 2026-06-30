extends Node2D
class_name ElevationZone
## Defines the floor elevation over a rectangular area; Units sample it each
## frame (group "elevation_zones") to set their ground height.
##  - Flat platform/pit: set `floor_height` (positive = raised, negative = sunken).
##  - Ramp: set `is_ramp = true`; height interpolates `ramp_low`→`ramp_high`
##    along `ramp_axis` (local space), so you can walk smoothly up onto a plateau
##    or down into a tunnel.

@export var size: Vector2 = Vector2(256, 256)
@export var floor_height: float = 40.0
@export var is_ramp: bool = false
@export var ramp_low: float = 0.0
@export var ramp_high: float = 40.0
## Local direction along which height increases, e.g. (0,-1) = toward top of screen.
@export var ramp_axis: Vector2 = Vector2(0, -1)
@export var debug_draw: bool = true

func _ready() -> void:
	add_to_group("elevation_zones")
	queue_redraw()

func contains_point(p: Vector2) -> bool:
	var local := to_local(p)
	return absf(local.x) <= size.x * 0.5 and absf(local.y) <= size.y * 0.5

func height_at(p: Vector2) -> float:
	if not is_ramp:
		return floor_height
	var axis := ramp_axis.normalized()
	var local := to_local(p)
	var half := (size * axis.abs()).length() * 0.5
	if half <= 0.0:
		return ramp_low
	var t := clampf((local.dot(axis) + half) / (2.0 * half), 0.0, 1.0)
	return lerpf(ramp_low, ramp_high, t)

func _draw() -> void:
	if not debug_draw:
		return
	var top := maxf(floor_height, maxf(ramp_low, ramp_high)) if is_ramp else floor_height
	var col := Color(0.25, 0.6, 1.0, 0.16) if top >= 0.0 else Color(0.15, 0.15, 0.25, 0.32)
	draw_rect(Rect2(-size * 0.5, size), col, true)
	draw_rect(Rect2(-size * 0.5, size), Color(1, 1, 1, 0.22), false, 2.0)
