extends Resource
class_name Special_Controller

const CHANGE_COLOR = preload("uid://be7po518l0752")
const WEAPON_OBTAINED_SFX = preload("uid://clswbxpktn0qf")

func special_collected(name: String):
	if name == "wip_upgrade":
		upgrade_wip()
	elif name == "cruz":
		cruz_effect()
	elif name == "jarro":
		jarro_effect()
		
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
	
func cruz_effect():
	var enemies = Engine.get_main_loop().get_nodes_in_group("enemy")
	for enemy in enemies:
		if enemy.is_on_screen:
			enemy.die()
			
	var color_black = true
	var tree = Engine.get_main_loop()
	for i in range(14):
		if color_black:
			RenderingServer.set_default_clear_color(Color.html("#FFFFFFFF"))
			color_black = false
		else:
			RenderingServer.set_default_clear_color(Color.html("#000000FF"))
			color_black = true
		
		await tree.create_timer(0.02, true).timeout
func jarro_effect():
	pass
