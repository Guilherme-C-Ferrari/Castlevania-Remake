extends CharacterBody2D
@export var walk_direction: Vector2
@export var move_speed: float = 75

func _ready() -> void:
	$FSM/MoveLinear.move_speed = move_speed
	$FSM/MoveLinear.walk_direction = walk_direction
