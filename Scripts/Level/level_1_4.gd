extends BaseLevel

func _ready() -> void:
	SignalManager.boss_won.connect(boss_beaten)
	stage_value = 3
	tile_map_layer = get_node("Bat Boss Room/TileMapLayer")
	super()

func boss_beaten():
	SignalManager.next_level_reached.emit(next_level)
	
