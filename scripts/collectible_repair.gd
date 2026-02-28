extends Node2D

var pickup_radius: float = 35.0
var repair_amount: float = 25.0
var player = null

func setup(p_player) -> void:
	player = p_player
	# Draw a simple green rect as visual
	var rect = ColorRect.new()
	rect.size = Vector2(18, 18)
	rect.offset_left = -9
	rect.offset_top = -9
	rect.color = Color(0.2, 1.0, 0.4, 0.9)
	add_child(rect)

func _process(_delta: float) -> void:
	if player == null:
		return
	if global_position.distance_to(player.global_position) < pickup_radius:
		player.collect_repair(repair_amount)
		queue_free()
