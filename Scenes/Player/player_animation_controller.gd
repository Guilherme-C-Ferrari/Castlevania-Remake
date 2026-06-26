extends Node

@onready var player: CharacterBody2D = get_parent()

func player_animation_control():	
	move_animation()
	jump_animation()
	duck_animation()
	attack_animation()

func move_animation():
	if player.player_can_control:
		if player.move_pressed != 0 and player.is_on_floor() and !player.is_attacking:
			player.is_walking = true
			if player.move_pressed == 1:
				player.visual.scale = Vector2(-1, player.visual.scale.y)
				player.player_combat_controller.scale = Vector2(-1, player.visual.scale.y)
			else:
				player.visual.scale = Vector2(1, player.visual.scale.y)
				player.player_combat_controller.scale = Vector2(1, player.visual.scale.y)
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
		
	if player.duck_pressed and player.is_on_floor():
		player.is_ducking = true
		player.is_walking = false

func attack_animation():
	if player.attack_pressed and player.playback.get_current_node() != "Attack_State":
		player.is_attacking = true
