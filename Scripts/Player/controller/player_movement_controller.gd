extends Node

func handle_movement(player, delta):

	if player.is_hurt:
		return

	# GRAVIDADE
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta

	# JUMP
	if player.is_jumping and player.is_on_floor() and !player.is_ducking and !player.is_attacking:
		player.velocity.y = player.JUMP_VELOCITY

	# MOVIMENTO HORIZONTAL
	if !player.is_jumping and player.is_on_floor() and !player.is_ducking and !player.is_attacking:
		if player.moving > 0.0:
			player.velocity.x = player.moving * player.SPEED
		elif player.moving < 0.0:
			player.velocity.x = player.moving * player.SPEED
		else:
			player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
	elif player.is_ducking:
		player.velocity.x = 0
	elif player.is_attacking and !player.is_jumping:
		player.velocity.x = 0

	player.move_and_slide()
