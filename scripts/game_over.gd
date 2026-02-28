extends CanvasLayer

func _ready() -> void:
	$VBox/RetryButton.pressed.connect(_on_retry_pressed)
	$VBox/MenuButton.pressed.connect(_on_menu_pressed)

func setup(depth: float, reason: String) -> void:
	$VBox/DepthReached.text = "MAX DEPTH: %dm" % int(depth)
	$VBox/DeathReason.text = reason

func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Game.tscn")

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Menu.tscn")
