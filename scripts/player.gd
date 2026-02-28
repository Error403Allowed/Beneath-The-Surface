extends CharacterBody2D

# ---- Stats ----
var speed: float = 200.0
var oxygen: float = 100.0
var oxygen_max: float = 100.0
var hull: float = 100.0
var hull_max: float = 100.0

# ---- Drain rates (per second) ----
var oxygen_drain_rate: float = 3.0
var pressure_damage_rate: float = 0.0   # set by DepthManager

# ---- State ----
var is_dead: bool = false

# ---- Signals ----
signal died(reason: String)
signal stats_changed(oxygen: float, hull: float)

func _ready() -> void:
	# Size the collision shape
	var shape = RectangleShape2D.new()
	shape.size = Vector2(40, 20)
	$CollisionShape2D.shape = shape

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	_handle_movement(delta)
	_drain_oxygen(delta)
	_apply_pressure(delta)
	emit_signal("stats_changed", oxygen, hull)

func _handle_movement(_delta: float) -> void:
	var dir := Vector2.ZERO
	if Input.is_action_pressed("move_up"):    dir.y -= 1
	if Input.is_action_pressed("move_down"):  dir.y += 1
	if Input.is_action_pressed("move_left"):  dir.x -= 1
	if Input.is_action_pressed("move_right"): dir.x += 1

	if dir.length() > 0:
		dir = dir.normalized()

	velocity = dir * speed
	move_and_slide()

	# Clamp horizontal so sub stays on screen
	position.x = clamp(position.x, -600.0, 600.0)
	# Don't let sub go above starting area
	position.y = clamp(position.y, -300.0, 9999999.0)

func _drain_oxygen(delta: float) -> void:
	oxygen -= oxygen_drain_rate * delta
	oxygen = clamp(oxygen, 0.0, oxygen_max)
	if oxygen <= 0.0:
		_die("Oxygen depleted.")

func _apply_pressure(delta: float) -> void:
	if pressure_damage_rate > 0.0:
		hull -= pressure_damage_rate * delta
		hull = clamp(hull, 0.0, hull_max)
		if hull <= 0.0:
			_die("Hull crushed by pressure.")

func take_damage(amount: float) -> void:
	hull -= amount
	hull = clamp(hull, 0.0, hull_max)
	if hull <= 0.0:
		_die("Hull destroyed by enemy.")

func collect_oxygen(amount: float) -> void:
	oxygen = clamp(oxygen + amount, 0.0, oxygen_max)

func collect_repair(amount: float) -> void:
	hull = clamp(hull + amount, 0.0, hull_max)

func _die(reason: String) -> void:
	if is_dead:
		return
	is_dead = true
	emit_signal("died", reason)
