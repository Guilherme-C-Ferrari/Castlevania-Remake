extends EnemyState
class_name FlyingZigueZague

func enter() -> void:
	if animated_sprite:
		if not animated_sprite.is_playing() or animated_sprite.animation != "Moving":
			animated_sprite.play("Moving")

func physics_update(_delta: float) -> void:
	character.velocity.x = character.walk_direction * character.move_speed
	handle_animation()
	character.move_and_slide()

func handle_animation() -> void:
	var move_direction = character.velocity.normalized()
	if move_direction.x > 0.0:
		animated_sprite.flip_h = true
	elif move_direction.x < 0.0:
		animated_sprite.flip_h = false
