extends LevelWithDoor

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stage_value = 1
	tile_map_layer = get_node("Entrance Hall/TileMapLayer")
	super()

func play_open_door_animation():
	animated_sprite_door.show()
	animated_sprite_door.play("open")

func play_close_door_animation():
	animated_sprite_door.play("close")
	await animated_sprite_door.animation_finished
	animated_sprite_door.hide()

#criar script base_level pra n repetir codigo
