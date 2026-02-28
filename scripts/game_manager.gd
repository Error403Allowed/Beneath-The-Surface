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
	depth_manager_node.setup(player, background, canvas_modulate, enemy_spawner_node)
	enemy_spawner_node.setup(player, depth_manager_node)
	collectible_spawner_node.setup(player)
	hud.setup(player, depth_manager_node)
	player.died.connect(_on_player_died)

func _on_player_died(reason: String) -> void:
	await get_tree().create_timer(1.0).timeout
	var go = load("res://scenes/GameOver.tscn").instantiate()
	get_tree().root.add_child(go)
	go.setup(depth_manager_node.max_depth, reason)
	queue_free()
