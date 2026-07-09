extends Node2D

@export var next_level: PackedScene

const SFX_ENTER_CASTLE = preload("uid://dr48wti68t6ax")

@onready var player: CharacterBody2D = $Player
@onready var fake_player: AnimatedSprite2D = $FakePlayer
@onready var change_scene_animation_player: AnimationPlayer = $ChangeSceneAnimationPlayer
@onready var area_2d: Area2D = $"Castle Entrance/Area2D"
@onready var tile_map_layer: TileMapLayer = $"Castle Entrance/TileMapLayer"

func _ready() -> void:
	AudioManager.play_current_music()
	SignalManager.level_loaded.emit(tile_map_layer)

func move_to_center_of_castle_entrance():
	change_scene_animation_player.speed_scale = 24 / abs(fake_player.position.x - area_2d.position.x)
	if fake_player.position.x <= area_2d.position.x:
		fake_player.flip_h = false
	else:
		fake_player.flip_h = true

func move_to_right_of_castle_entrance():
	change_scene_animation_player.speed_scale = 1
	fake_player.flip_h = false
	AudioManager.play_sound_effect(SFX_ENTER_CASTLE, "SFX", -10)

func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		var anim: Animation = change_scene_animation_player.get_animation("entering_castle")
		var track_id: int = anim.find_track("FakePlayer:position", Animation.TYPE_VALUE)
		var key_id: int = anim.track_find_key(track_id, 0.0)
		anim.track_set_key_value(track_id, key_id, player.position)
		change_scene_animation_player.play("entering_castle")
		change_scene_animation_player.play("entering_castle")

func next_level_reached():
	print("enviou novo signal")
	SignalManager.next_level_reached.emit(next_level)
