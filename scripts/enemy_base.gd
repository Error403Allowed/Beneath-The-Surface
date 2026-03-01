extends CharacterBody2D

# ---- Config ----
var speed: float = 80.0
var detection_range: float = 300.0
var damage_per_second: float = 8.0
var health: float = 30.0
var is_boss: bool = false

# ---- State machine ----
enum State { PATROL, CHASE }
var state: State = State.PATROL

var player: CharacterBody2D = null
var patrol_dir: Vector2 = Vector2.RIGHT
var patrol_timer: float = 0.0
var patrol_switch_time: float = 2.5

func setup(p_player: CharacterBody2D, boss: bool = false) -> void:
	player = p_player
	is_boss = boss
	if boss:
		speed = 120.0
		health = 120.0
		damage_per_second = 15.0
		detection_range = 450.0
		if has_node("EnemySprite"):
			$EnemySprite.scale = Vector2(0.25, 0.25)
	patrol_dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

func _physics_process(delta: float) -> void:
	if player == null or player.is_dead:
		return

	var dist = global_position.distance_to(player.global_position)

	match state:
		State.PATROL:
			_patrol(delta)
			if dist < detection_range:
				state = State.CHASE

		State.CHASE:
			_chase(delta)
			if dist > detection_range * 1.5:
				state = State.PATROL

	# Contact damage
	if dist < 30.0:
		player.take_damage(damage_per_second * delta)

func _patrol(delta: float) -> void:
	patrol_timer += delta
	if patrol_timer >= patrol_switch_time:
		patrol_timer = 0.0
		patrol_dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

	velocity = patrol_dir * speed * 0.5
	move_and_slide()

func _chase(_delta: float) -> void:
	var dir = (player.global_position - global_position).normalized()
	velocity = dir * speed
	move_and_slide()

func take_hit(amount: float) -> void:
	health -= amount
	if health <= 0.0:
		queue_free()
