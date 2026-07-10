extends EnemyState
class_name MovingLinear

func enter() -> void:
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
	if character.is_on_floor():
		if character.is_on_wall():
			character.walk_direction *= -1
		character.velocity.x = character.walk_direction * character.move_speed
	else:
		character.velocity += character.get_gravity() * _delta
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
