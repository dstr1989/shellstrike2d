extends Node
## Autoload. Spawns a one-shot animated effect from a horizontal sprite strip.

var _cache: Dictionary = {}

func _tex(path: String) -> Texture2D:
	if not _cache.has(path):
		_cache[path] = load(path)
	return _cache[path]

func _frames_for(strip: Texture2D, count: int) -> SpriteFrames:
	var sf := SpriteFrames.new()
	sf.add_animation("a")
	sf.set_animation_loop("a", false)
	sf.set_animation_speed("a", 1.0)
	var fw := strip.get_width() / count
	var fh := strip.get_height()
	for i in count:
		var at := AtlasTexture.new()
		at.atlas = strip
		at.region = Rect2(i * fw, 0, fw, fh)
		sf.add_frame("a", at)
	return sf

func play(strip: Texture2D, count: int, world_pos: Vector2, fps: float = 18.0, scale: float = 1.0, rot: float = 0.0) -> void:
	var tree := get_tree()
	if tree == null or tree.current_scene == null:
		return
	var spr := AnimatedSprite2D.new()
	spr.sprite_frames = _frames_for(strip, count)
	spr.global_position = world_pos
	spr.scale = Vector2.ONE * scale
	spr.rotation = rot
	spr.z_index = 60
	spr.speed_scale = fps
	tree.current_scene.add_child(spr)
	spr.play("a")
	spr.animation_finished.connect(spr.queue_free)

func muzzle(pos: Vector2, rot: float) -> void:
	play(_tex("res://assets/sprites/fx/fx_muzzle.png"), 4, pos, 26.0, 0.7, rot)

func impact(pos: Vector2) -> void:
	play(_tex("res://assets/sprites/fx/fx_impact.png"), 4, pos, 24.0, 0.7)

func splash(pos: Vector2) -> void:
	play(_tex("res://assets/sprites/fx/fx_splash.png"), 5, pos, 18.0, 0.7)

func dust(pos: Vector2) -> void:
	play(_tex("res://assets/sprites/fx/fx_dust.png"), 5, pos, 20.0, 0.7)

func death(pos: Vector2) -> void:
	play(_tex("res://assets/sprites/fx/fx_death.png"), 6, pos, 18.0, 0.9)
