extends CharacterBody2D
class_name Unit
## Shared controller for both Tortoises and Rabbits, human-controlled or AI.
## A child BotAI node (see bot_ai.gd) drives this via set_desired_move /
## set_desired_aim / set_firing when `is_ai` is true. Otherwise input comes
## from the TouchInput singleton (touch sticks, or keyboard/mouse fallback).

signal fired(from_pos: Vector2, to_pos: Vector2, hit: bool)

@export var team: Global.Team = Global.Team.TORTOISE
@export var is_ai: bool = false
@export var move_speed: float = 200.0
@export var fire_rate: float = 6.0 # shots per second
@export var damage_per_shot: int = 24
@export var weapon_range: float = 900.0
@export var bullet_spread_degrees: float = 2.5

@onready var health: HealthComponent = $HealthComponent
@onready var visual: Node2D = $Visual
@onready var shadow: Sprite2D = $Shadow
@onready var body: Sprite2D = $Visual/Body
@onready var aim_pivot: Node2D = $Visual/AimPivot
@onready var weapon: Sprite2D = $Visual/AimPivot/Weapon
@onready var muzzle: Marker2D = $Visual/AimPivot/Muzzle
@onready var muzzle_flash: Polygon2D = $Visual/AimPivot/MuzzleFlash
@onready var health_bar: Node2D = $Visual/HealthBar
@onready var health_fill: ColorRect = $Visual/HealthBar/Fill
@onready var prompt_label: Label = $Visual/PromptLabel

# --- Elevation / jumping (top-down z-height simulation) ---
const GRAVITY := 900.0
const JUMP_VELOCITY := 330.0
const VAULT_HEIGHT := 16.0      # above this, you clear low (vaultable) cover
const LOW_COVER_BIT := 5        # collision layer bit 5 (value 16) = vaultable cover

var z_height: float = 0.0       # current elevation above the floor under us
var z_vel: float = 0.0
var ground_height: float = 0.0  # floor elevation at our position (ramps/platforms)
var _on_ground: bool = true

# --- Procedural animation (Brawl-Stars-style juice) ---
var _anim_t: float = 0.0
var _recoil: float = 0.0
var _base_body_scale: Vector2 = Vector2.ONE
var _weapon_base_x: float = 28.0

# Per-match stats (kill feed / scoreboard).
var kills: int = 0
var deaths: int = 0

# Fallback textures if no skin is registered (keeps the unit visible).
const FALLBACK_TORTOISE := preload("res://assets/sprites/tortoise_topdown.svg")
const FALLBACK_RABBIT := preload("res://assets/sprites/rabbit_topdown.svg")

var _fire_cooldown: float = 0.0
var _flash_timer: float = 0.0
var _aim_dir: Vector2 = Vector2.RIGHT
var _ai_move: Vector2 = Vector2.ZERO
var _ai_aim: Vector2 = Vector2.RIGHT
var _ai_firing: bool = false
var _ai_interacting: bool = false
var _carrying_charge: bool = false # rabbits only: true until charge planted

func _ready() -> void:
	add_to_group("respawnable")
	add_to_group("units")
	health.died.connect(_on_died)
	health.damaged.connect(_on_damaged)
	GameManager.register_actor(self)
	muzzle_flash.visible = false
	_refresh_health_bar()
	prompt_label.text = ""
	if team == Global.Team.RABBIT:
		_carrying_charge = true
	_apply_skin()
	_base_body_scale = body.scale
	_weapon_base_x = weapon.position.x
	# The unit body never rotates (top-down upright look); only AimPivot does.
	rotation = 0.0
	# layers: 1=world 2=tortoises 4=rabbits 8=bullets 16=low(vaultable) cover
	collision_layer = 2 if team == Global.Team.TORTOISE else 4
	collision_mask = 1 | 2 | 4 | 16

var _shield_texture: Texture2D = null

func _apply_skin() -> void:
	var skin: CharacterSkin = SkinManager.get_active(team)
	if skin != null and skin.body_texture != null:
		body.texture = skin.body_texture
		body.scale = Vector2.ONE * skin.body_scale
		_shield_texture = skin.shield_texture
		if skin.weapon_texture != null:
			weapon.texture = skin.weapon_texture
	else:
		body.texture = FALLBACK_TORTOISE if team == Global.Team.TORTOISE else FALLBACK_RABBIT
	# Scale the weapon to a consistent on-screen length regardless of source size.
	if weapon.texture != null:
		weapon.scale = Vector2.ONE * (46.0 / float(weapon.texture.get_width()))

func _physics_process(delta: float) -> void:
	if not health.is_alive():
		velocity = Vector2.ZERO
		return
	if GameManager.phase == Global.RoundPhase.ROUND_END or GameManager.phase == Global.RoundPhase.WARMUP:
		velocity = Vector2.ZERO
		return

	var move_input := _ai_move if is_ai else TouchInput.get_move_vector()
	velocity = move_input.normalized() * move_speed if move_input.length() > 0.0 else Vector2.ZERO
	move_and_slide()

	_update_elevation(delta)

	var aim_input := _get_aim_input()
	if aim_input.length() > 0.05:
		_aim_dir = aim_input.normalized()
	_update_facing()
	_animate(delta)

	_fire_cooldown = max(0.0, _fire_cooldown - delta)
	var firing := _ai_firing if is_ai else TouchInput.is_firing()
	if firing and _fire_cooldown <= 0.0:
		_shoot()

	if _flash_timer > 0.0:
		_flash_timer -= delta
		if _flash_timer <= 0.0:
			muzzle_flash.visible = false

	var interacting := _ai_interacting if is_ai else TouchInput.is_interacting()
	if interacting:
		_try_interact()

	if not is_ai:
		_update_prompt()

func _update_elevation(delta: float) -> void:
	var target_ground := _sample_ground_height()
	if _on_ground:
		if target_ground >= ground_height - 1.0:
			ground_height = target_ground   # follow ramp up / flat ground
			z_height = ground_height
		else:
			ground_height = target_ground   # stepped off a ledge → start falling
			_on_ground = false
	else:
		ground_height = target_ground

	if _on_ground and not is_ai and Input.is_action_just_pressed("jump"):
		z_vel = JUMP_VELOCITY
		_on_ground = false

	if not _on_ground:
		z_vel -= GRAVITY * delta
		z_height += z_vel * delta
		if z_height <= ground_height:
			z_height = ground_height
			z_vel = 0.0
			_on_ground = true

	# While high enough off the floor, pass over low (vaultable) cover.
	var clearing := (z_height - ground_height) > VAULT_HEIGHT
	set_collision_mask_value(LOW_COVER_BIT, not clearing)

	# Lift the visuals; shrink/fade the shadow with altitude.
	visual.position.y = -z_height
	var t := clampf(z_height / 120.0, 0.0, 1.0)
	shadow.scale = Vector2.ONE * lerpf(0.85, 0.5, t)
	shadow.modulate.a = lerpf(0.35, 0.12, t)

func _animate(delta: float) -> void:
	_anim_t += delta
	_recoil = maxf(0.0, _recoil - delta * 6.0)

	var sx := _base_body_scale.x
	var sy := _base_body_scale.y
	if not _on_ground:
		# Stretch going up, squash coming down.
		var s := clampf(z_vel / 650.0, -0.22, 0.22)
		sx = _base_body_scale.x * (1.0 - s)
		sy = _base_body_scale.y * (1.0 + s)
		body.position.y = lerpf(body.position.y, 0.0, 0.3)
	elif velocity.length() > 12.0:
		# Walk: vertical bob + light squash.
		var b := sin(_anim_t * 16.0)
		body.position.y = -absf(b) * 5.0
		var sq := 0.07 * b
		sx = _base_body_scale.x * (1.0 + sq * 0.5)
		sy = _base_body_scale.y * (1.0 - sq * 0.5)
	else:
		# Idle breathing.
		body.position.y = lerpf(body.position.y, 0.0, 0.2)
		var br := 0.03 * sin(_anim_t * 3.0)
		sx = _base_body_scale.x * (1.0 - br)
		sy = _base_body_scale.y * (1.0 + br)
	body.scale = Vector2(sx, sy)

	# Weapon recoil kicks the gun back toward the body.
	weapon.position.x = _weapon_base_x - _recoil * 8.0

func _sample_ground_height() -> float:
	var h := 0.0
	for zone in get_tree().get_nodes_in_group("elevation_zones"):
		if zone.has_method("contains_point") and zone.contains_point(global_position):
			h = maxf(h, zone.height_at(global_position))
	return h

func _get_aim_input() -> Vector2:
	if is_ai:
		return _ai_aim
	# Touch aim stick takes priority; otherwise aim at the world mouse position
	# (get_global_mouse_position accounts for the camera, screen coords do not).
	if TouchInput.aim_vector.length() > 0.05:
		return TouchInput.aim_vector
	return get_global_mouse_position() - global_position

func _update_facing() -> void:
	# Body stays upright (Brawl-Stars-style); only the weapon arm tracks aim.
	var angle := _aim_dir.angle()
	aim_pivot.rotation = angle
	# Flip the whole rig horizontally so the body faces the aim side.
	if _aim_dir.x < -0.05:
		body.flip_h = true
		aim_pivot.scale = Vector2(1, -1) # keep weapon upright when facing left
	elif _aim_dir.x > 0.05:
		body.flip_h = false
		aim_pivot.scale = Vector2(1, 1)

func _shoot() -> void:
	_fire_cooldown = 1.0 / fire_rate
	_recoil = 1.0
	var spread := deg_to_rad(randf_range(-bullet_spread_degrees, bullet_spread_degrees))
	var dir := _aim_dir.rotated(spread)
	var space_state := get_world_2d().direct_space_state
	var query := PhysicsRayQueryParameters2D.create(
		muzzle.global_position,
		muzzle.global_position + dir * weapon_range
	)
	query.exclude = [self]
	var enemy_layer := 4 if team == Global.Team.TORTOISE else 2
	query.collision_mask = 1 | enemy_layer # world + opposing team only
	var result := space_state.intersect_ray(query)
	var hit := false
	var end_pos := muzzle.global_position + dir * weapon_range
	if result:
		end_pos = result.position
		var collider = result.get("collider")
		if collider and collider.has_method("_on_hit_by_bullet"):
			collider._on_hit_by_bullet(damage_per_shot, self)
			hit = true
	_spawn_shot_fx(muzzle.global_position, end_pos, hit)
	fired.emit(muzzle.global_position, end_pos, hit)

func _spawn_shot_fx(from_pos: Vector2, to_pos: Vector2, hit: bool) -> void:
	# Muzzle flash (brief).
	muzzle_flash.visible = true
	_flash_timer = 0.04
	# Tracer line, fades out and frees itself.
	var tracer := Line2D.new()
	tracer.width = 3.0
	tracer.default_color = Color(1.0, 0.86, 0.34, 0.9)
	tracer.points = PackedVector2Array([from_pos, to_pos])
	tracer.z_index = 50
	var scene_root := get_tree().current_scene
	if scene_root == null:
		return
	scene_root.add_child(tracer)
	var tw := tracer.create_tween()
	tw.tween_property(tracer, "modulate:a", 0.0, 0.09)
	tw.tween_callback(tracer.queue_free)
	# Impact spark.
	var spark := Polygon2D.new()
	spark.color = Color(1.0, 0.7, 0.2, 1.0) if hit else Color(0.9, 0.9, 0.9, 0.8)
	spark.polygon = PackedVector2Array([Vector2(-5, 0), Vector2(0, -5), Vector2(5, 0), Vector2(0, 5)])
	spark.global_position = to_pos
	spark.z_index = 50
	scene_root.add_child(spark)
	var tw2 := spark.create_tween()
	tw2.set_parallel(true)
	tw2.tween_property(spark, "scale", Vector2(2.2, 2.2), 0.12)
	tw2.tween_property(spark, "modulate:a", 0.0, 0.12)
	tw2.chain().tween_callback(spark.queue_free)

func _on_hit_by_bullet(amount: int, attacker: Node) -> void:
	if attacker and "team" in attacker and attacker.team == team:
		return # no friendly fire in MVP
	health.apply_damage(amount, attacker)

func _on_damaged(_amount: int, _current_hp: int, _attacker: Node) -> void:
	_refresh_health_bar()
	body.modulate = Color(1, 0.45, 0.45)
	create_tween().tween_property(body, "modulate", Color.WHITE, 0.18)

func _refresh_health_bar() -> void:
	var frac := clampf(float(health.current_hp) / float(health.max_hp), 0.0, 1.0)
	health_fill.scale.x = frac
	health_fill.color = Color(0.36, 0.85, 0.45) if frac > 0.35 else Color(0.9, 0.4, 0.3)

func _update_prompt() -> void:
	var charge := get_tree().get_first_node_in_group("carrot_charge")
	var txt := ""
	if charge != null:
		if team == Global.Team.RABBIT and is_carrying_charge() and charge.can_plant_at(global_position):
			txt = "Przytrzymaj [E] — podłóż ładunek"
		elif team == Global.Team.TORTOISE and charge.can_defuse_at(global_position):
			txt = "Przytrzymaj [E] — rozbrój"
	prompt_label.text = txt
	prompt_label.visible = txt != ""

func _try_interact() -> void:
	var charge := get_tree().get_first_node_in_group("carrot_charge")
	if charge == null:
		return
	if team == Global.Team.RABBIT and _carrying_charge:
		charge.try_plant(self)
	elif team == Global.Team.TORTOISE:
		charge.try_defuse(self)

func _on_died(attacker: Node) -> void:
	velocity = Vector2.ZERO
	visible = false
	set_physics_process(false)
	deaths += 1
	GameManager.log_kill(attacker, self)
	GameManager.notify_actor_died(self)

func respawn_for_new_round() -> void:
	health.reset_health()
	visible = true
	set_physics_process(true)
	_carrying_charge = team == Global.Team.RABBIT
	body.modulate = Color.WHITE
	muzzle_flash.visible = false
	prompt_label.text = ""
	z_height = 0.0
	z_vel = 0.0
	ground_height = 0.0
	_on_ground = true
	visual.position.y = 0.0
	set_collision_mask_value(LOW_COVER_BIT, true)
	_refresh_health_bar()
	var spawn_group := "tortoise_spawns" if team == Global.Team.TORTOISE else "rabbit_spawns"
	var spawns := get_tree().get_nodes_in_group(spawn_group)
	if spawns.size() > 0:
		global_position = spawns[randi() % spawns.size()].global_position

# --- AI control surface (used by bot_ai.gd) ---
func set_desired_move(v: Vector2) -> void:
	_ai_move = v

func set_desired_aim(v: Vector2) -> void:
	_ai_aim = v

func set_firing(value: bool) -> void:
	_ai_firing = value

func set_interacting(value: bool) -> void:
	_ai_interacting = value

func notify_charge_planted_by_me() -> void:
	_carrying_charge = false

func is_carrying_charge() -> bool:
	return _carrying_charge
