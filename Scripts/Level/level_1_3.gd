extends LevelWithDoor

@onready var level_1_3_1: Node2D = $Level1_3_1

@onready var offset_level_1_3_2: Node2D = $"Offset Level1_3_2"

const LEVEL_1_3_2 = preload("uid://d1spkvjd6hjvy")

var level_1_3_2: Node2D

var above: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stage_value = 2
	tile_map_layer = get_node("Level1_3_1/Crypt A/TileMapLayer")
	level_1_3_2 = LEVEL_1_3_2.instantiate(PackedScene.GEN_EDIT_STATE_MAIN_INHERITED)
	level_1_3_2.visible = false
	level_1_3_2.process_mode = Node.PROCESS_MODE_DISABLED
	offset_level_1_3_2.add_child(level_1_3_2)
	super()

func _on_stair_transition_body_entered(body: Node2D) -> void:
	var player_body = get_tree().get_first_node_in_group("player")
	if body == player_body:
		player_body.is_on_cutscene = true
		self.hide()
		Ui.visible = false
		swap_levels()
		
		await get_tree().create_timer(0.5).timeout
		self.show()
		Ui.visible = true
		#auto_walk_stairs()
		player_body.is_on_cutscene = false

#func auto_walk_stairs()
	#if above

func swap_levels():
	if above:
		level_1_3_1.visible = false
		level_1_3_1.process_mode = Node.PROCESS_MODE_DISABLED
		level_1_3_2.visible = true
		level_1_3_2.process_mode = Node.PROCESS_MODE_INHERIT
		tile_map_layer = get_node("Offset Level1_3_2/Level1_3_2/Crypt B/TileMapLayer")
		camera_reference.update_camera_limits(tile_map_layer)
		player.descend_pressed = true
		player.ascend_pressed = false
		above = false
	else:
		level_1_3_1.visible = true
		level_1_3_1.process_mode = Node.PROCESS_MODE_INHERIT
		level_1_3_2.visible = false
		level_1_3_2.process_mode = Node.PROCESS_MODE_DISABLED
		tile_map_layer = get_node("Level1_3_1/Crypt A/TileMapLayer")
		camera_reference.update_camera_limits(tile_map_layer)
		player.ascend_pressed = true
		player.descend_pressed = false
		above = true
