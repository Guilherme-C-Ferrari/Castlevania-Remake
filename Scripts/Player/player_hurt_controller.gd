extends Node

func handle_hurt(player, delta):

	if player.is_hurt:
		player.hurt_timer -= delta

		player.velocity.x = player.knockback_velocity.x
		player.velocity.y += player.get_gravity().y * player.HURT_GRAVITY * delta

		player.move_and_slide()

		if player.hurt_timer <= 0 and player.is_on_floor():
			player.is_hurt = false
			player.player_can_control = true
			player.knockback_velocity = Vector2.ZERO

			if !player.is_dead:
				start_invincibility(player)
			else:
				player.player_can_control = false


func take_hit(player, enemy_facing: Vector2):

	if player.invincible:
		return

	player.is_hurt = true
	player.player_can_control = false
	player.hurt_timer = player.HURT_TIME

	var dir = enemy_facing.normalized()

	player.knockback_velocity = Vector2(
		dir.x * player.KNOCKBACK_FORCE,
		player.HURT_HEIGHT
	)

	player.is_attacking = false
	player.is_jumping = false
	player.is_ducking = false
	player.is_walking = false
	player.moving = 0

	player.velocity = player.knockback_velocity

	player.set_collision_layer_value(2, false)


func start_invincibility(player) -> void:

	player.invincible = true
	player.set_collision_layer_value(2, false)

	var tween = player.get_tree().create_tween()
	tween.tween_property(player.visual, "modulate:a", 0.3, 0.15)

	await player.get_tree().create_timer(player.INVINCIBILITY_TIME).timeout

	end_invincibility(player)


func end_invincibility(player) -> void:

	player.invincible = false
	player.set_collision_layer_value(2, true)

	var tween = player.get_tree().create_tween()
	tween.tween_property(player.visual, "modulate:a", 1.0, 0.15)
