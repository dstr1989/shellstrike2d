extends Node
## Autoload singleton. Registry of all available skins per team and which one is
## currently selected. Units ask it for their team's active skin on spawn.
## To add a skin (e.g. AI-generated): drop a CharacterSkin .tres in
## res://assets/skins/, add its path to DEFAULT_SKINS (or call register()).

const DEFAULT_SKINS := [
	"res://assets/skins/tortoise_default.tres",
	"res://assets/skins/rabbit_default.tres",
]

var skins_by_team: Dictionary = {}    # team:int -> Array[CharacterSkin]
var selected_index: Dictionary = {}   # team:int -> int

func _ready() -> void:
	for path in DEFAULT_SKINS:
		var skin := load(path) as CharacterSkin
		if skin != null:
			register(skin)

func register(skin: CharacterSkin) -> void:
	if not skins_by_team.has(skin.team):
		skins_by_team[skin.team] = []
		selected_index[skin.team] = 0
	skins_by_team[skin.team].append(skin)

func get_skins_for(team: int) -> Array:
	return skins_by_team.get(team, [])

func get_active(team: int) -> CharacterSkin:
	var arr: Array = skins_by_team.get(team, [])
	if arr.is_empty():
		return null
	var idx: int = selected_index.get(team, 0)
	return arr[idx]

func select(team: int, index: int) -> void:
	if skins_by_team.has(team):
		selected_index[team] = clampi(index, 0, skins_by_team[team].size() - 1)

func select_by_id(team: int, skin_id: String) -> void:
	var arr: Array = skins_by_team.get(team, [])
	for i in arr.size():
		if arr[i].skin_id == skin_id:
			selected_index[team] = i
			return
