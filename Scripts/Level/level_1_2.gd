extends Node2D

@export var next_level: PackedScene

@onready var tile_map_layer: TileMapLayer = $"Entrance Hall/TileMapLayer"
@onready var player: CharacterBody2D = $Player
@onready var fake_player: AnimatedSprite2D = $FakePlayer
@onready var animated_sprite_door: AnimatedSprite2D = $"AnimatedSprite Door"
@onready var next_level_spawn_location: Marker2D = $"Next Level Spawn Location"

var camera_reference: Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.respond_camera_reference.connect(update_camera_reference)
	SignalManager.level_loaded.emit(tile_map_layer)
	SignalManager.player_spawned.emit(player)
	SignalManager.request_camera_reference.emit()

func update_camera_reference(new_camera_reference: Camera2D):
	camera_reference = new_camera_reference

func play_open_door_animation():
	animated_sprite_door.show()
	animated_sprite_door.play("open")

func play_close_door_animation():
	animated_sprite_door.play("close")
	await animated_sprite_door.animation_finished
	animated_sprite_door.hide()

func move_camera_to_right_first(amount: float):
	var tween = create_tween()
	tween.tween_property(camera_reference, "offset", (camera_reference.offset + Vector2(amount, 0)), 2)

#camera ta flickando qnd troca a scene, resolver
#criar script base_level pra n repetir codigo
func _on_next_level_trigger_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		#despawna level
		player.player_can_control = false
		player.hide()
		fake_player.stop()
		fake_player.position = player.position
		fake_player.show()
		move_camera_to_right_first(128)
		await get_tree().create_timer(2.0).timeout
		animated_sprite_door.show()
		animated_sprite_door.play("open")
		await animated_sprite_door.animation_finished
		var tween = create_tween()
		tween.tween_property(fake_player, "position", next_level_spawn_location.position, 1)
		fake_player.play("default")
		await get_tree().create_timer(1.0).timeout
		fake_player.stop()
		animated_sprite_door.play("close")
		await animated_sprite_door.animation_finished
		animated_sprite_door.hide()
		await get_tree().create_timer(0.3).timeout
		move_camera_to_right_first(128)
		await get_tree().create_timer(2.0).timeout
		SignalManager.next_level_reached.emit(next_level)
