extends Node

@onready var player: CharacterBody2D = get_parent()

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
	if player.attack_pressed and player.playback.get_current_node() != "Attack_State":
		player.is_attacking = true
		
func stair_animation():
	if !(player.is_ascending or player.is_descending):
		return

	if player.is_moving_on_stair and !player.is_attacking:
		player.animated_sprite_player.play()
	else:
		if player.is_attacking:
			pass
		else:	
			player.animated_sprite_player.frame = 0
			player.animated_sprite_player.pause()
		
		
