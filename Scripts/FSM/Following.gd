extends EnemyState
class_name Following

var player: CharacterBody2D = null

func enter() -> void:
	player = get_tree().get_first_node_in_group("player")
	if animated_sprite:
		if not animated_sprite.is_playing() or animated_sprite.animation != "Moving":
			animated_sprite.play("Moving")
	if character and character.get("can_shoot") == true:
		var timer = character.get_node_or_null("Timer")
		if timer:
			timer.timeout.connect(_on_timer_timeout)
			if timer.is_stopped():
				timer.start()

func physics_update(_delta: float) -> void:
	if not player:
		return
	
	if not character.is_on_floor():
		if character.get("is_spawner_jumper"):
			character.velocity += character.get_gravity() * _delta
		else:
			transitioned.emit(self, "Jumping")
			return
	
	var direction_to_player
	var dist_x = abs(player.global_position.x - character.global_position.x)
	var dist_y = abs(player.global_position.y - character.global_position.y)
	
	if (dist_x > 150.0 and dist_x < 200) or (dist_y <= 10 and dist_x < 200):
		direction_to_player = sign(player.global_position.x - character.global_position.x)
	else:
		direction_to_player = character.walk_direction
	
	if dist_x < 10.0 and dist_y < 10.0:
		transitioned.emit(self, "MovingLinear")
		return
	else:
		character.velocity.x = direction_to_player * character.move_speed
	
	handle_animation()
	character.move_and_slide()

func exit() -> void:
	if character and character.get_node_or_null("Timer"):
		if character.get_node("Timer").timeout.is_connected(_on_timer_timeout):
			character.get_node("Timer").timeout.disconnect(_on_timer_timeout)

func handle_animation() -> void:
	var move_direction = character.velocity.normalized()
	if move_direction.x > 0.0:
		animated_sprite.flip_h = true
	elif move_direction.x < 0.0:
		animated_sprite.flip_h = false

func _on_timer_timeout() -> void:
	transitioned.emit(self, "Shooting")
