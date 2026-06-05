extends CharacterBody2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var move_direction = velocity.normalized()
	if not is_on_floor():
		velocity += get_gravity() * delta
	if move_direction.x > 0.0:
		animated_sprite.flip_h = true
	elif move_direction.x < 0.0:
		animated_sprite.flip_h = false
	move_and_slide()
