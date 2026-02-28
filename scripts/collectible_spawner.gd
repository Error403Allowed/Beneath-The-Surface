extends Node2D

# Spawns oxygen tanks and repair kits as the player descends

var spawn_interval: float = 4.0
var spawn_timer: float = 0.0
var player: CharacterBody2D = null

func setup(p_player) -> void:
	player = p_player

func _process(delta: float) -> void:
	if player == null or player.is_dead:
		return
	spawn_timer += delta
	if spawn_timer >= spawn_interval:
		spawn_timer = 0.0
		_spawn_collectible()

func _spawn_collectible() -> void:
	# 60% chance oxygen, 40% chance repair kit
	var is_oxygen = randf() < 0.6
	var item = Node2D.new()
	item.set_script(
		load("res://scripts/collectible_oxygen.gd") if is_oxygen
		else load("res://scripts/collectible_repair.gd")
	)

	# Spawn ahead of player (below + random X)
	var px = player.global_position.x + randf_range(-250, 250)
	var py = player.global_position.y + randf_range(200, 500)
	item.global_position = Vector2(px, py)
	item.call_deferred("setup", player)
	add_child(item)
