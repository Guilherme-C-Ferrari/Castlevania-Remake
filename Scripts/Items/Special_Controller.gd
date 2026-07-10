extends Resource
class_name Special_Controller
const CHANGE_COLOR = preload("uid://be7po518l0752")

const WEAPON_OBTAINED_SFX = preload("uid://clswbxpktn0qf")

func special_collected(name: String):
	if name == "wip_upgrade":
		upgrade_wip()
		
func upgrade_wip():
	AudioManager.play_sound_effect(WEAPON_OBTAINED_SFX, "SFX", -12)
	Ui.upgrade_wip_level()
	
	var tree = Engine.get_main_loop()
	var player = tree.get_first_node_in_group("player")
	
	if player:
		var wip_sprite = player.get_node("Visual/AnimatedSpritePlayer")
		
		tree.paused = true
		
		if wip_sprite:
			wip_sprite.material = CHANGE_COLOR
			
		await tree.create_timer(1.0, true).timeout
		
		if wip_sprite:
			wip_sprite.material = null
			
		tree.paused = false
	
