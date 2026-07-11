extends Resource
class_name Special_Controller

const CHANGE_COLOR_SHADER = preload("uid://be7po518l0752")
const INVENSIBLE_SHADER = preload("uid://d00ygg04g3wai")


const WEAPON_OBTAINED_SFX = preload("uid://clswbxpktn0qf")
const CROSS_FLASHES_SFX = preload("uid://d2plcr0i5p5hl")

var player = Engine.get_main_loop().get_first_node_in_group("player")

func _init() -> void:
	SignalManager.player_spawned.connect(update_player_reference)

func update_player_reference(new_player: CharacterBody2D):
	player = new_player

var flashes_count := 14
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
		var player_sprite = player.get_node("Visual/AnimatedSpritePlayer")
		
		tree.paused = true
		
		if player_sprite:
			player_sprite.material = CHANGE_COLOR_SHADER
			
		await tree.create_timer(1.0, true).timeout
		
		if player_sprite:
			player_sprite.material = null
			
		tree.paused = false
	
func cruz_effect():
	AudioManager.play_sound_effect(CROSS_FLASHES_SFX, "SFX", -6)
	var enemies = Engine.get_main_loop().get_nodes_in_group("enemy")
	for enemy in enemies:
		if enemy.is_on_screen:
			enemy.die()
			
	var color_black = true
	var tree = Engine.get_main_loop()
	for i in range(flashes_count):
		if color_black:
			RenderingServer.set_default_clear_color(Color.html("#FFFFFFFF"))
			color_black = false
		else:
			RenderingServer.set_default_clear_color(Color.html("#000000FF"))
			color_black = true
		
		await tree.create_timer(0.02, true).timeout
		
func jarro_effect():
	start_invincibility()
	
func start_invincibility() -> void:
	var tree = Engine.get_main_loop()
	
	player.invincible = true
	player.set_collision_layer_value(2, false)
	
	var tween = player.get_tree().create_tween()
	tween.tween_property(player.visual, "modulate:a", 0.3, 0.15)
	
	await tree.create_timer(2.0, true).timeout
	
	var player_sprite = player.get_node("Visual/AnimatedSpritePlayer")
	
	if player_sprite:
			player_sprite.material = INVENSIBLE_SHADER
	
	await tree.create_timer(3.0, true).timeout
	
	end_invincibility()


func end_invincibility() -> void:
	print("ACABOU")
	var tree = Engine.get_main_loop()
	
	var player_sprite = player.get_node("Visual/AnimatedSpritePlayer")
	
	if player_sprite:
			player_sprite.material = null
	
	await tree.create_timer(2.0, true).timeout
	
	player.set_collision_layer_value(2, true)
	player.invincible = false
	
	var tween = player.get_tree().create_tween()
	tween.tween_property(player.visual, "modulate:a", 1.0, 0.15)
