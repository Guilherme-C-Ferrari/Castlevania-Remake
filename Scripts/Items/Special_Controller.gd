extends Resource
class_name Special_Controller

const WEAPON_OBTAINED_SFX = preload("uid://clswbxpktn0qf")

func special_collected(name: String):
	if name == "wip_upgrade":
		upgrade_wip()
		
func upgrade_wip():
	AudioManager.play_sound_effect(WEAPON_OBTAINED_SFX, "SFX", -12)
	Ui.upgrade_wip_level()
	
