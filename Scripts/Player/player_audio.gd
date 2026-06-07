extends Node
const WHIP_SFX = preload("uid://b1x36h5p0hjvy")


func play_wip_attack_sfx():
	AudioManager.play_sound_effect(WHIP_SFX,"SFX", -13, 0.8, 1.07)
