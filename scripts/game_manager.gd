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
	# Store stats so GameOver can read them after scene change
	var max_d = depth_manager_node.max_depth
	var death_reason = reason
	get_tree().set_meta("max_depth", max_d)
	get_tree().set_meta("death_reason", death_reason)
	get_tree().change_scene_to_file("res://scenes/GameOver.tscn")
