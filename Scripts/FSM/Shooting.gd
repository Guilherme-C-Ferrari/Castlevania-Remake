extends EnemyState
class_name Shooting

func enter() -> void:
	if animated_sprite:
		if not animated_sprite.is_playing() or animated_sprite.animation != "Shooting":
			animated_sprite.play("Shooting")
	character.spawn_projectile()
	await get_tree().create_timer(1.5).timeout
	transitioned.emit(self, "Following")
