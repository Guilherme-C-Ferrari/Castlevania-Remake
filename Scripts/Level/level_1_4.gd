extends BaseLevel

func _ready() -> void:
	stage_value = 3
	tile_map_layer = get_node("Bat Boss Room/TileMapLayer")
	super()
