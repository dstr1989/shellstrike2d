extends Control

func _on_oasis_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MapOasis.tscn")

func _on_burrow_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_warren_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MapWarren.tscn")
