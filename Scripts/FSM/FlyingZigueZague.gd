extends EnemyState
class_name FlyingZigueZague

var time: float = 0.0

func enter() -> void:
	if animated_sprite:
		if not animated_sprite.is_playing() or animated_sprite.animation != "Moving":
			animated_sprite.play("Moving")

func physics_update(_delta: float) -> void:
	time += _delta
	character.velocity.x = character.move_speed * character.walking_direction
	character.velocity.y = sin(time * character.flying_frequency) * character.flying_amplitude
	handle_animation()
	character.move_and_slide()

func handle_animation() -> void:
	var move_direction = character.velocity.normalized()
	if move_direction.x > 0.0:
		animated_sprite.flip_h = true
	elif move_direction.x < 0.0:
		animated_sprite.flip_h = false
