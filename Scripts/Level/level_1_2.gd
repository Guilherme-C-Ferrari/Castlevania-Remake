extends LevelWithDoor

func _ready() -> void:
	stage_value = 1
	tile_map_layer = get_node("Entrance Hall/TileMapLayer")
	super()
