extends Node2D
class_name CharacterRig
## Multi-part character built from limb cutouts, animated procedurally
## (walk leg/arm swing, idle, jump tuck, ear jiggle, tortoise shell-turn).
## Lives as the "Body" node inside a Unit; the Unit still drives overall
## scale (facing+squash), position bob and modulate (damage flash).

const PART_DIR := "res://assets/sprites/parts/"

func _tex(name: String) -> Texture2D:
	return load(PART_DIR + name + ".png")

var _p: Dictionary = {}
var _team: int = Global.Team.TORTOISE
var _t: float = 0.0
var _shielding: bool = false

func setup(team: int) -> void:
	_team = team
	for c in get_children():
		c.queue_free()
	_p.clear()
	if team == Global.Team.TORTOISE:
		_build_tortoise()
	else:
		_build_rabbit()

func _mk(key: String, tex: Texture2D, pos: Vector2, z: int, offset: Vector2 = Vector2.ZERO, flip: bool = false) -> Sprite2D:
	var s := Sprite2D.new()
	s.texture = tex
	s.position = pos
	s.z_index = z
	s.offset = offset
	if flip:
		s.scale.x = -1.0
	add_child(s)
	_p[key] = s
	return s

func _build_tortoise() -> void:
	_mk("leg_b", _tex("tort_leg"), Vector2(-34, 118), 1, Vector2(0, 55))
	_mk("leg_f", _tex("tort_leg"), Vector2(34, 118), 2, Vector2(0, 55), true)
	_mk("arm_b", _tex("tort_arm"), Vector2(-104, -6), 1, Vector2(0, 45))
	_mk("torso", _tex("tort_shell"), Vector2(0, 24), 3)
	_mk("head", _tex("tort_head"), Vector2(0, -112), 4)
	_mk("arm_f", _tex("tort_arm"), Vector2(104, -6), 5, Vector2(0, 45), true)
	var sb := _mk("shell_back", _tex("tort_shell_back"), Vector2(0, -8), 8)
	sb.scale = Vector2(1.15, 1.15)
	sb.visible = false

func _build_rabbit() -> void:
	_mk("ear_b", _tex("rab_ear"), Vector2(-42, -150), 0, Vector2(0, 70))
	_mk("ear_f", _tex("rab_ear"), Vector2(42, -150), 0, Vector2(0, 70), true)
	_mk("leg_b", _tex("rab_leg"), Vector2(-32, 120), 1, Vector2(0, 55))
	_mk("leg_f", _tex("rab_leg"), Vector2(32, 120), 2, Vector2(0, 55), true)
	_mk("arm_b", _tex("rab_arm"), Vector2(-98, -4), 1, Vector2(0, 45))
	_mk("torso", _tex("rab_torso"), Vector2(0, 26), 3)
	_mk("head", _tex("rab_head"), Vector2(0, -120), 4)
	_mk("arm_f", _tex("rab_arm"), Vector2(98, -4), 5, Vector2(0, 45), true)

func set_shielding(value: bool) -> void:
	_shielding = value

func animate_parts(delta: float, moving: bool, airborne: bool) -> void:
	_t += delta
	var ph := sin(_t * 13.0)
	var swing := ph * 0.5 if (moving and not airborne) else 0.0
	if airborne:
		swing = 0.0

	_rot("leg_b", swing if not airborne else -0.5)
	_rot("leg_f", -swing if not airborne else -0.5)
	_rot("arm_b", (-swing * 0.7) if not _shielding else 0.4)
	_rot("arm_f", (swing * 0.7) if not _shielding else -0.4)

	# Ears: gentle jiggle plus a flop while moving (rabbit only).
	var ear := 0.12 * sin(_t * 9.0) + (0.18 if moving else 0.0)
	_rot_to("ear_b", -0.15 - ear, 0.2)
	_rot_to("ear_f", 0.15 + ear, 0.2)

	# Tortoise shell-turn: when shielding, present the back shell, hide the rest.
	if _p.has("shell_back"):
		var s := _shielding
		_p["shell_back"].visible = s
		_set_vis("head", not s)
		_set_vis("torso", not s)
		_set_vis("arm_f", not s)
		_set_vis("arm_b", not s)

func _rot(key: String, target: float) -> void:
	if _p.has(key):
		_p[key].rotation = lerp_angle(_p[key].rotation, target, 0.3)

func _rot_to(key: String, target: float, w: float) -> void:
	if _p.has(key):
		_p[key].rotation = lerp_angle(_p[key].rotation, target, w)

func _set_vis(key: String, v: bool) -> void:
	if _p.has(key):
		_p[key].visible = v
