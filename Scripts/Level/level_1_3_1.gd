extends BaseLevel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tile_map_layer = get_node("Crypt A/TileMapLayer")
	super()
