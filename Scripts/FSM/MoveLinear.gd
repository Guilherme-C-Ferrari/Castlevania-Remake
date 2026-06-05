extends State
class_name MoveLinear

@export var character: CharacterBody2D
@export var move_speed: float = 75.0
@export var walk_direction: Vector2
	
func physics_update(_delta: float) -> void:
	if character.is_on_floor():
		character.velocity = walk_direction * move_speed
