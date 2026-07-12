extends EnemyState
class_name BossIdling

func enter() -> void:
	if animated_sprite:
		if not animated_sprite.is_playing() or animated_sprite.animation != "Idling":
			animated_sprite.play("Idling")

func physics_update(_delta: float) -> void:
	if character.is_active:
		transitioned.emit(self, "PhantomBatMenancing") 
