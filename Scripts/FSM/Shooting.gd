extends EnemyState
class_name Shooting

@onready var fireball_projectile: PackedScene = preload("res://Scenes/Enemy/Projectiles/fireball.tscn")

func enter() -> void:
	if animated_sprite:
		if not animated_sprite.is_playing() or animated_sprite.animation != "Shooting":
			animated_sprite.play("Shooting")
	
	var fireball = fireball_projectile.instantiate()
	fireball.global_position = character.global_position
	
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var direction = sign(player.global_position.x - character.global_position.x)
		fireball.walk_direction = direction
	character.add_child(fireball)
	
	await get_tree().create_timer(2.0).timeout
	transitioned.emit(self, "Following")
