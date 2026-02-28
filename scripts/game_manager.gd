extends Node2D

# ---- Node references ----
@onready var player: CharacterBody2D = $Player
@onready var background: ColorRect = $Background
@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var enemy_spawner_node: Node2D = $EnemySpawner
@onready var collectible_spawner_node: Node2D = $CollectibleSpawner
@onready var depth_manager_node: Node = $DepthManager
@onready var hud: CanvasLayer = $HUD

func _ready() -> void:
	_init_depth_manager()
	_init_enemy_spawner()
	_init_collectible_spawner()
	_init_hud()
	player.died.connect(_on_player_died)

func _init_depth_manager() -> void:
	depth_manager_node.set_script(load("res://scripts/depth_manager.gd"))
	depth_manager_node.setup(player, background, canvas_modulate, enemy_spawner_node)

func _init_enemy_spawner() -> void:
	enemy_spawner_node.set_script(load("res://scripts/enemy_spawner.gd"))
	enemy_spawner_node.setup(player, depth_manager_node)

func _init_collectible_spawner() -> void:
	collectible_spawner_node.set_script(load("res://scripts/collectible_spawner.gd"))
	collectible_spawner_node.setup(player)

func _init_hud() -> void:
	hud.setup(player, depth_manager_node)

func _on_player_died(reason: String) -> void:
	# Brief pause then load game over screen
	await get_tree().create_timer(1.0).timeout
	var go = load("res://scenes/GameOver.tscn").instantiate()
	get_tree().root.add_child(go)
	go.setup(depth_manager_node.max_depth, reason)
	queue_free()
