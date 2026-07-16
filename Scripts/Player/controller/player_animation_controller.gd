extends Node

@onready var player: CharacterBody2D = get_parent()

const WHIP_SFX = preload("uid://b1x36h5p0hjvy")
@onready var wip: Node2D = $"../Visual/wip"
@onready var wip_collision_shape_2d: CollisionShape2D = $"../Player_Combat_Controller/Wip_Attack_Area/CollisionShape2D"

func player_animation_control():	
	move_animation()
	jump_animation()
	duck_animation()
	attack_animation()
	stair_animation()

func move_animation():
	if player.player_can_control:
		if player.move_pressed != 0 and player.is_on_floor() and !player.is_attacking and !player.player_stair_controller.is_using_stair:
			player.is_walking = true
			if player.move_pressed == 1:
				player.turn_player("RIGHT")
			else:
				player.turn_player("LEFT")
		else:
			player.is_walking = false
		
		if player.move_pressed != 0:
			player.moving = player.move_pressed
		else:
			player.moving = 0

func jump_animation():
	if player.is_on_floor():
		player.is_jumping = false
	
	if player.jump_pressed and player.is_on_floor():
		player.is_jumping = true
		player.is_walking = false

func duck_animation():
	if !player.duck_pressed:
		player.is_ducking = false
		
	if player.duck_pressed and player.is_on_floor() \
	and !player.player_stair_controller.is_on_stair_area \
	and !player.player_stair_controller.is_using_stair \
	and !player.is_moving_on_stair:
		
		player.is_ducking = true
		player.is_walking = false

func attack_animation():
	if player.ascend_pressed and player.attack_pressed and Ui.can_use_weapon() and !player.is_using_special :
		print("special")
		wip.visible = false
		
		Ui.use_weapon(player.global_position, player.visual.scale.x)
		player.is_attacking = true
		player.is_using_special = true
		return
	
	if player.attack_pressed and player.playback.get_current_node() != "Attack_State":
		print("WIP ATACK")
		AudioManager.play_sound_effect(WHIP_SFX,"SFX", -13, 0.8, 1.07)
		wip.visible = true
		player.is_attacking = true
		
func stair_animation():
	if !(player.is_ascending or player.is_descending):
		return

	if player.is_moving_on_stair and !player.is_attacking:
		player.animated_sprite_player.play()
	else:
		if player.is_attacking or player.animated_sprite_player.animation == "attack_ascending_stairs" or player.animated_sprite_player.animation == "attack_descending_stairs":
			pass
		else:
			player.animated_sprite_player.frame = 0
			player.animated_sprite_player.pause()
			
func enable_wip_attack():
	if player.is_using_special:
		return
	wip_collision_shape_2d.disabled = false
	
func disable_wip_attack():
	wip_collision_shape_2d.disabled = true
