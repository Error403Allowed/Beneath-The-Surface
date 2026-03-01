extends Node2D

var pickup_radius: float = 35.0
var repair_amount: float = 25.0
var player = null

func setup(p_player) -> void:
	player = p_player
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/repair.png")
	sprite.scale = Vector2(0.12, 0.12)
	add_child(sprite)

func _process(_delta: float) -> void:
	if player == null:
		return
	if global_position.distance_to(player.global_position) < pickup_radius:
		player.collect_repair(repair_amount)
		queue_free()
