extends Control

@onready var side_button: Button = $Buttons/SideButton

func _ready() -> void:
	_refresh_side()

func _on_side_pressed() -> void:
	Loadout.player_team = Global.opposite(Loadout.player_team)
	_refresh_side()

func _refresh_side() -> void:
	if Loadout.player_team == Global.Team.TORTOISE:
		side_button.text = "Strona: Żółw 🐢"
	else:
		side_button.text = "Strona: Królik 🐇"

func _on_oasis_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MapOasis.tscn")

func _on_burrow_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_warren_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MapWarren.tscn")
