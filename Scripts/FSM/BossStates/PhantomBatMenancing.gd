extends EnemyState
class_name PhantomBatMenancing

var player: CharacterBody2D = null

func enter() -> void:
	player = get_tree().get_first_node_in_group("player")
	if animated_sprite:
		if not animated_sprite.is_playing() or animated_sprite.animation != "Fighting":
			animated_sprite.play("Fighting")
