extends EnemyState
class_name PhantomBatShooting

@export var fireball_scene: PackedScene

var shoot_timer: float = 0.6

func enter() -> void:
	shoot_timer = 0.6
	if animated_sprite:
		if not animated_sprite.is_playing() or animated_sprite.animation != "Fighting":
			animated_sprite.play("Fighting") 
