extends Node2D

func _ready() -> void:
	var dbg := Node2D.new()
	dbg.set_script(preload("res://scripts/debug_overlay.gd"))
	add_child(dbg)
	GameManager.start_match()
