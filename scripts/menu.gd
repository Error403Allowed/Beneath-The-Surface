extends CanvasLayer

func _ready() -> void:
	$VBox/StartButton.pressed.connect(_on_start_pressed)
	$VBox/QuitButton.pressed.connect(_on_quit_pressed)

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Game.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
