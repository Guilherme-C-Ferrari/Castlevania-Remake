extends Node2D
const FOOTSTEP = preload("uid://cqcc4byoexdbq")
const ABANDONED_CASTLE = preload("uid://6n6xst4hsxtf")

func _ready() -> void:
	AudioManager.stop_music()

func footstep_sfx():
	AudioManager.play_sound_effect(FOOTSTEP, "SFX", -12)
	
func play_credits_music():
	Ui.visible = false
	AudioManager.change_current_music(ABANDONED_CASTLE)
