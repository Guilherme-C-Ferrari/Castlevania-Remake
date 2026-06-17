extends EnemyState
class_name Jumping

func enter() -> void:
	if animated_sprite:
		animated_sprite.play("Jumping")
	jump()

func physics_update(_delta: float) -> void:
	character.velocity += character.get_gravity() * _delta
	if character.is_on_floor():
		transitioned.emit(self, "Following")
		return
	character.move_and_slide()

func jump() -> void:
	if character:
		character.velocity.y = -100.0
