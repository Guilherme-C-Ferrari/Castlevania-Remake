extends EnemyState
class_name Jumping

func enter() -> void:
	if animated_sprite:
		animated_sprite.play("Jumping")
