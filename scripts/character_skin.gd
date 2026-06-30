extends Resource
class_name CharacterSkin
## One visual skin for a character. Swappable at runtime — the gameplay code
## never references textures directly, only the active CharacterSkin. New skins
## (incl. AI-generated art) are added by creating a .tres in res://assets/skins/
## and registering it; no code changes required.

@export var skin_id: String = ""
@export var display_name: String = ""
## 1 = Tortoise, 2 = Rabbit (matches Global.Team).
@export var team: int = 1
## Top-down body art, facing RIGHT, upright, weapon NOT included. ~512x512 PNG.
@export var body_texture: Texture2D
## Optional menu/shop portrait. Falls back to body_texture if empty.
@export var icon_texture: Texture2D
## Optional per-skin weapon art (side view, barrel pointing right). Falls back
## to the unit's default weapon if empty.
@export var weapon_texture: Texture2D
## Tortoise only: shell-shield overlay art shown when the shield is raised.
@export var shield_texture: Texture2D
## Uniform render scale applied to the body sprite for this skin.
@export var body_scale: float = 0.7

func get_icon() -> Texture2D:
	return icon_texture if icon_texture != null else body_texture
