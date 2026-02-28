extends Node

# ---- Zone definitions ----
# Each entry: [name, min_depth, max_depth, bg_color, light_scale, pressure_dmg, spawn_rate]
const ZONES = [
	{"name": "SUNLIT ZONE",   "min": 0,    "max": 200,  "color": Color(0.04, 0.12, 0.25),  "light": 1.0,  "pressure": 0.0,  "spawn": 2.0},
	{"name": "TWILIGHT ZONE", "min": 200,  "max": 1000, "color": Color(0.02, 0.06, 0.15),  "light": 0.6,  "pressure": 2.0,  "spawn": 1.5},
	{"name": "MIDNIGHT ZONE", "min": 1000, "max": 4000, "color": Color(0.01, 0.02, 0.08),  "light": 0.3,  "pressure": 5.0,  "spawn": 0.8},
	{"name": "ANCIENT RUINS", "min": 4000, "max": 99999,"color": Color(0.02, 0.01, 0.05),  "light": 0.15, "pressure": 10.0, "spawn": 0.5},
]

signal zone_changed(zone_data: Dictionary)

var current_zone_index: int = 0
var current_depth: float = 0.0
var max_depth: float = 0.0

var player: CharacterBody2D = null
var background: ColorRect = null
var canvas_modulate: CanvasModulate = null
var spawner = null

func setup(p_player, p_bg, p_mod, p_spawner) -> void:
	player = p_player
	background = p_bg
	canvas_modulate = p_mod
	spawner = p_spawner

func _process(_delta: float) -> void:
	if player == null:
		return
	current_depth = max(player.global_position.y, 0.0) / 10.0
	if current_depth > max_depth:
		max_depth = current_depth
	_check_zone()

func _check_zone() -> void:
	for i in ZONES.size():
		var z = ZONES[i]
		if current_depth >= z.min and current_depth < z.max:
			if i != current_zone_index:
				current_zone_index = i
				emit_signal("zone_changed", z)
				_apply_zone(z)
			return

func _apply_zone(z: Dictionary) -> void:
	if background:
		var tween = create_tween()
		tween.tween_property(background, "color", z.color, 2.0)

	if canvas_modulate:
		var tween2 = create_tween()
		tween2.tween_property(canvas_modulate, "color",
			Color(z.light, z.light, z.light + 0.1, 1.0), 2.0)

	if player:
		player.pressure_damage_rate = z.pressure

	if spawner:
		spawner.spawn_interval = z.spawn

func get_zone_name() -> String:
	return ZONES[current_zone_index].name
