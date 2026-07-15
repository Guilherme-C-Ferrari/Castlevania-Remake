extends EnemyState
class_name Jumping

func enter() -> void:
	if animated_sprite:
		if character.get("is_spawner_jumper"):
			animated_sprite.play("Idling")
		else:
			animated_sprite.play("Jumping")
	jump()

func physics_update(_delta: float) -> void:
	character.velocity += character.get_gravity() * _delta
	
	if character.get("is_spawner_jumper"):
		if character.velocity.y < 0:
			character.set_collision_mask_value(1, false)
		else:
			character.set_collision_mask_value(1, true)
		if character.is_on_floor() and character.velocity.y >= 0:
			transitioned.emit(self, "Idling")
			return
	elif character.is_on_floor():
		transitioned.emit(self, "Following")
		return
		
	character.move_and_slide()

func jump() -> void:
	if character:
		if character.get("is_spawner_jumper"):
			character.velocity.y = -450.0
			character.velocity.x = 0.0
		else:
			character.velocity.y = -100.0
			character.velocity.x = 180.0 * character.walk_direction
