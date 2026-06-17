extends EnemyState
class_name Following

var player: CharacterBody2D = null

func enter() -> void:
	player = get_tree().get_first_node_in_group("player")
	if animated_sprite:
		if not animated_sprite.is_playing() or animated_sprite.animation != "Moving":
			animated_sprite.play("Moving")

func physics_update(_delta: float) -> void:
	if not player:
		return
	
	if not character.is_on_floor():
		transitioned.emit(self, "Jumping")
		return
	
	var direction_to_player = sign(player.global_position.x - character.global_position.x)
	var dist_x = abs(player.global_position.x - character.global_position.x)
	var dist_y = abs(player.global_position.y - character.global_position.y)
	
	if dist_x < 15.0 and dist_y < 15.0:
		transitioned.emit(self, "MovingLinear")
		return
	else:
		character.velocity.x = direction_to_player * character.move_speed
	
	handle_animation()
	character.move_and_slide()

func handle_animation() -> void:
	var move_direction = character.velocity.normalized()
	if move_direction.x > 0.0:
		animated_sprite.flip_h = true
	elif move_direction.x < 0.0:
		animated_sprite.flip_h = false
