extends Node

func _ready() -> void:
	call_deferred("_load_menu")

func _load_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/Menu.tscn")
