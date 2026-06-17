extends EnemyState
class_name Following

func enter() -> void:
	if animated_sprite:
		if not animated_sprite.is_playing() or animated_sprite.animation != "Moving":
			animated_sprite.play("Moving")
