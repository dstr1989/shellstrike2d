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
@onready var muzzle: Marker2D = $Muzzle
@onready var sprite: Sprite2D = $Sprite

const TORTOISE_TEXTURE := preload("res://assets/sprites/tortoise_topdown.svg")
const RABBIT_TEXTURE := preload("res://assets/sprites/rabbit_topdown.svg")

var _fire_cooldown: float = 0.0
var _ai_move: Vector2 = Vector2.ZERO
var _ai_aim: Vector2 = Vector2.RIGHT
var _ai_firing: bool = false
var _ai_interacting: bool = false
var _carrying_charge: bool = false # rabbits only: true until charge planted

func _ready() -> void:
	add_to_group("respawnable")
	add_to_group("units")
	health.died.connect(_on_died)
	GameManager.register_actor(self)
	if team == Global.Team.RABBIT:
		_carrying_charge = true
	sprite.texture = TORTOISE_TEXTURE if team == Global.Team.TORTOISE else RABBIT_TEXTURE
	# layers: 1=world 2=tortoises 4=rabbits 8=bullets 16=interactables
	collision_layer = 2 if team == Global.Team.TORTOISE else 4
	collision_mask = 1 | 2 | 4

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

	var aim_input := _ai_aim if is_ai else TouchInput.get_aim_vector(global_position)
	if aim_input.length() > 0.05:
		rotation = aim_input.angle()

	_fire_cooldown = max(0.0, _fire_cooldown - delta)
	var firing := _ai_firing if is_ai else TouchInput.is_firing()
	if firing and _fire_cooldown <= 0.0:
		_shoot()

	var interacting := _ai_interacting if is_ai else TouchInput.is_interacting()
	if interacting:
		_try_interact()

func _shoot() -> void:
	_fire_cooldown = 1.0 / fire_rate
	var spread := deg_to_rad(randf_range(-bullet_spread_degrees, bullet_spread_degrees))
	var dir := Vector2.RIGHT.rotated(rotation + spread)
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
	fired.emit(muzzle.global_position, end_pos, hit)

func _on_hit_by_bullet(amount: int, attacker: Node) -> void:
	if attacker and "team" in attacker and attacker.team == team:
		return # no friendly fire in MVP
	health.apply_damage(amount, attacker)

func _try_interact() -> void:
	var charge := get_tree().get_first_node_in_group("carrot_charge")
	if charge == null:
		return
	if team == Global.Team.RABBIT and _carrying_charge:
		charge.try_plant(self)
	elif team == Global.Team.TORTOISE:
		charge.try_defuse(self)

func _on_died(_attacker: Node) -> void:
	velocity = Vector2.ZERO
	visible = false
	set_physics_process(false)
	GameManager.notify_actor_died(self)

func respawn_for_new_round() -> void:
	health.reset_health()
	visible = true
	set_physics_process(true)
	_carrying_charge = team == Global.Team.RABBIT
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
