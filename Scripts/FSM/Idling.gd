extends EnemyState
class_name Idling

func enter() -> void:
	if animated_sprite:
		if not animated_sprite.is_playing() or animated_sprite.animation != "Idling":
			animated_sprite.play("Idling")
