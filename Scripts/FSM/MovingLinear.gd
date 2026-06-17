extends EnemyState
class_name MovingLinear

func physics_update(_delta: float) -> void:
	if character.is_on_floor():
		character.velocity = character.walk_direction * character.move_speed
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
