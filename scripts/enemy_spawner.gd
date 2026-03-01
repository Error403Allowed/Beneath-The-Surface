extends Node2D

# ---- Config ----
var spawn_interval: float = 2.0
var max_enemies: int = 12
var spawn_timer: float = 0.0
var boss_depth_threshold: float = 4000.0
var boss_spawned: bool = false

var player: CharacterBody2D = null
var depth_manager = null

func setup(p_player, p_depth_manager) -> void:
	player = p_player
	depth_manager = p_depth_manager

func _process(delta: float) -> void:
	if player == null or player.is_dead:
		return

	_cull_distant_enemies()

	spawn_timer += delta
	if spawn_timer >= spawn_interval:
		spawn_timer = 0.0
		_try_spawn_enemy()

	if depth_manager and not boss_spawned:
		if depth_manager.current_depth >= boss_depth_threshold:
			_spawn_boss()
			boss_spawned = true

func _cull_distant_enemies() -> void:
	for child in get_children():
		if child.global_position.distance_to(player.global_position) > 900.0:
			child.queue_free()

func _try_spawn_enemy() -> void:
	if get_child_count() >= max_enemies:
		return

	var enemy = _make_enemy(false)
	add_child(enemy)

func _spawn_boss() -> void:
	var boss = _make_enemy(true)
	add_child(boss)

func _make_enemy(is_boss: bool) -> CharacterBody2D:
	var e = CharacterBody2D.new()
	e.set_script(load("res://scripts/enemy_base.gd"))

	# Collision
	var col = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(30, 20) if not is_boss else Vector2(60, 40)
	col.shape = shape
	e.add_child(col)

	# Sprite
	var sprite = Sprite2D.new()
	sprite.name = "EnemySprite"
	sprite.texture = load("res://assets/squid.png") if is_boss else load("res://assets/piranha.png")
	var scale_size = 0.15 if not is_boss else 0.25
	sprite.scale = Vector2(scale_size, scale_size)
	e.add_child(sprite)

	# Spawn offset to the side of player
	var offset_x = randf_range(300, 500) * (1 if randf() > 0.5 else -1)
	var offset_y = randf_range(-100, 100)
	e.global_position = player.global_position + Vector2(offset_x, offset_y)

	# Defer setup so node is in tree
	e.call_deferred("setup", player, is_boss)
	return e
