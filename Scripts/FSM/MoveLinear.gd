extends State
class_name MoveLinear

@export var character: CharacterBody2D
@export var animated_sprite: AnimatedSprite2D
@export var move_speed: float
@export var walk_direction: Vector2

func physics_update(_delta: float) -> void:
	if character.is_on_floor():
		character.velocity = walk_direction * move_speed
	
	var move_direction = character.velocity.normalized()
	
	if not character.is_on_floor():
		character.velocity += character.get_gravity() * _delta
	if move_direction.x > 0.0:
		animated_sprite.flip_h = true
	elif move_direction.x < 0.0:
		animated_sprite.flip_h = false
	character.move_and_slide()
