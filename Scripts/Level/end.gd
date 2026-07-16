extends Node2D

const FOOTSTEP = preload("uid://cqcc4byoexdbq")
const ABANDONED_CASTLE = preload("uid://6n6xst4hsxtf")

var camera_reference: Camera2D

func _ready() -> void:
	SignalManager.respond_camera_reference.connect(update_camera_reference)
	SignalManager.request_camera_reference.emit()
	reset_camera_position()
	AudioManager.stop_music()

func update_camera_reference(new_camera_reference: Camera2D):
	camera_reference = new_camera_reference

func reset_camera_position():
	camera_reference.position = Vector2(128, 120)

func footstep_sfx():
	AudioManager.play_sound_effect(FOOTSTEP, "SFX", -12)
	
func play_credits_music():
	Ui.visible = false
	AudioManager.change_current_music(ABANDONED_CASTLE)
	await get_tree().create_timer(30.0).timeout
	Ui.restart_ui()
	SignalManager.next_level_reached.emit("menu")
