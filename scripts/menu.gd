extends CanvasLayer

func _ready() -> void:
	$Card/VBox/StartButton.pressed.connect(_on_start_pressed)
	$Card/VBox/QuitButton.pressed.connect(_on_quit_pressed)
	_style_button($Card/VBox/StartButton, Color(0.1, 0.4, 0.7), Color(0.15, 0.55, 0.9))
	_style_button($Card/VBox/QuitButton, Color(0.05, 0.15, 0.3), Color(0.08, 0.25, 0.45))
	_animate_intro()

func _animate_intro() -> void:
	# Card slides up from below and fades in
	var card = $Card
	card.modulate.a = 0.0
	card.position.y += 40.0
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(card, "modulate:a", 1.0, 0.5)
	tween.parallel().tween_property(card, "position:y", card.position.y - 40.0, 0.5)

	# Title pulses gently
	var title = $Card/VBox/Title
	var pulse = create_tween().set_loops()
	pulse.tween_property(title, "modulate", Color(0.6, 1.0, 1.0, 1.0), 1.8).set_trans(Tween.TRANS_SINE)
	pulse.tween_property(title, "modulate", Color(0.4, 0.85, 1.0, 1.0), 1.8).set_trans(Tween.TRANS_SINE)

func _style_button(btn: Button, normal_color: Color, hover_color: Color) -> void:
	var normal = StyleBoxFlat.new()
	normal.bg_color = normal_color
	normal.corner_radius_top_left = 12
	normal.corner_radius_top_right = 12
	normal.corner_radius_bottom_left = 12
	normal.corner_radius_bottom_right = 12
	normal.content_margin_left = 24
	normal.content_margin_right = 24
	normal.content_margin_top = 14
	normal.content_margin_bottom = 14
	normal.border_width_top = 1
	normal.border_width_bottom = 1
	normal.border_width_left = 1
	normal.border_width_right = 1
	normal.border_color = Color(0.3, 0.7, 1.0, 0.4)

	var hover = StyleBoxFlat.new()
	hover.bg_color = hover_color
	hover.corner_radius_top_left = 12
	hover.corner_radius_top_right = 12
	hover.corner_radius_bottom_left = 12
	hover.corner_radius_bottom_right = 12
	hover.content_margin_left = 24
	hover.content_margin_right = 24
	hover.content_margin_top = 14
	hover.content_margin_bottom = 14
	hover.border_width_top = 1
	hover.border_width_bottom = 1
	hover.border_width_left = 1
	hover.border_width_right = 1
	hover.border_color = Color(0.4, 0.85, 1.0, 0.7)

	var pressed_style = StyleBoxFlat.new()
	pressed_style.bg_color = normal_color.darkened(0.2)
	pressed_style.corner_radius_top_left = 12
	pressed_style.corner_radius_top_right = 12
	pressed_style.corner_radius_bottom_left = 12
	pressed_style.corner_radius_bottom_right = 12
	pressed_style.content_margin_left = 24
	pressed_style.content_margin_right = 24
	pressed_style.content_margin_top = 14
	pressed_style.content_margin_bottom = 14

	btn.add_theme_stylebox_override("normal", normal)
	btn.add_theme_stylebox_override("hover", hover)
	btn.add_theme_stylebox_override("pressed", pressed_style)
	btn.add_theme_color_override("font_color", Color(0.85, 0.95, 1.0))
	btn.add_theme_color_override("font_hover_color", Color(1.0, 1.0, 1.0))

func _on_start_pressed() -> void:
	# Fade out then switch scene
	var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($Card, "modulate:a", 0.0, 0.3)
	tween.tween_callback(func(): get_tree().change_scene_to_file("res://scenes/Game.tscn"))

func _on_quit_pressed() -> void:
	get_tree().quit()
