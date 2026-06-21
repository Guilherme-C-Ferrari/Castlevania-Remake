extends EnemyState
class_name MovingLinear

func enter() -> void:
	if animated_sprite:
		if not animated_sprite.is_playing() or animated_sprite.animation != "Moving":
			animated_sprite.play("Moving")

func physics_update(_delta: float) -> void:
	if character.is_on_floor():
		if character.is_on_wall():
			character.walk_direction *= -1
		character.velocity.x = character.walk_direction * character.move_speed
	else:
		character.velocity += character.get_gravity() * _delta
	handle_animation()
	character.move_and_slide()

func handle_animation() -> void:
	var move_direction = character.velocity.normalized()
	if move_direction.x > 0.0:
		animated_sprite.flip_h = true
	elif move_direction.x < 0.0:
		animated_sprite.flip_h = false
