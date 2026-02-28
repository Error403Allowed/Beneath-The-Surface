extends CanvasLayer

var depth_manager = null
var player = null

func setup(p_player, p_depth_manager) -> void:
	player = p_player
	depth_manager = p_depth_manager
	player.stats_changed.connect(_on_stats_changed)

func _process(_delta: float) -> void:
	if depth_manager == null:
		return
	$DepthLabel.text = "DEPTH: %dm" % int(depth_manager.current_depth)
	$ZoneLabel.text = depth_manager.get_zone_name()

func _on_stats_changed(oxygen: float, hull: float) -> void:
	$OxygenBar.value = oxygen
	$HullBar.value = hull
	# Colour oxygen bar based on urgency (like a traffic light — green > yellow > red)
	if oxygen > 50:
		$OxygenBar.modulate = Color(0.3, 0.8, 1)
	elif oxygen > 25:
		$OxygenBar.modulate = Color(1, 0.9, 0.2)
	else:
		$OxygenBar.modulate = Color(1, 0.2, 0.2)

	if hull > 50:
		$HullBar.modulate = Color(0.3, 1, 0.5)
	elif hull > 25:
		$HullBar.modulate = Color(1, 0.7, 0.2)
	else:
		$HullBar.modulate = Color(1, 0.2, 0.2)
