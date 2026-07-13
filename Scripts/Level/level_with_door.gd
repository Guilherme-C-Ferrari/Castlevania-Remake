extends BaseLevel
class_name LevelWithDoor

@onready var animated_sprite_door: AnimatedSprite2D = $"AnimatedSprite Door"
@onready var next_level_spawn_location: Marker2D = $"Next Level Spawn Location"

func _on_next_level_trigger_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		despawn_level()
		var map_rect: Rect2 = tile_map_layer.get_used_rect()
		var tile_size: Vector2 = tile_map_layer.tile_set.tile_size
		self.position.x = -int(map_rect.position.x + map_rect.size.x) * int(tile_size.x)
		camera_reference.update_camera_limits(tile_map_layer)
		player.player_can_control = false
		camera_reference.can_follow_player = false
		player.hide()
		fake_player.stop()
		fake_player.position = player.position
		fake_player.show()
		camera_reference.position.x = int(map_rect.position.x + map_rect.size.x) * int(tile_size.x) + int(tile_map_layer.global_position.x) - 128
		camera_reference.increase_camera_limit_right(256)
		camera_reference.move_camera_to_right(128)
		await get_tree().create_timer(2.0).timeout
		animated_sprite_door.show()
		animated_sprite_door.play("open")
		AudioManager.play_sound_effect(SFX_DOOR, "SFX", -10)
		await animated_sprite_door.animation_finished
		var tween = create_tween()
		tween.tween_property(fake_player, "position", next_level_spawn_location.position, 1)
		fake_player.play("default")
		await get_tree().create_timer(1.0).timeout
		fake_player.stop()
		animated_sprite_door.play("close")
		AudioManager.play_sound_effect(SFX_DOOR, "SFX", -10)
		await animated_sprite_door.animation_finished
		animated_sprite_door.hide()
		await get_tree().create_timer(0.3).timeout
		camera_reference.move_camera_to_right(128)
		await get_tree().create_timer(2.0).timeout
		SignalManager.next_level_reached.emit(next_level)

func play_open_door_animation():
	animated_sprite_door.show()
	animated_sprite_door.play("open")

func play_close_door_animation():
	animated_sprite_door.play("close")
	await animated_sprite_door.animation_finished
	animated_sprite_door.hide()
