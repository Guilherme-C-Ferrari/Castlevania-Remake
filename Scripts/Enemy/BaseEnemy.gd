extends CharacterBody2D
class_name BaseEnemy

@export var hp: int = 1
@export var experience: int = 100
@export var damage: int = 2
@export var walk_direction: Vector2
@export var move_speed: float = 75
@onready var hit_box: Area2D = $Area2D

signal player_damaged(damage: int)

func _ready() -> void:
	hit_box.body_entered.connect(_on_player_damaged)

func _on_player_damaged(_body: Node2D) -> void:
	player_damaged.emit(damage)

func on_receive_damage(amount: int) -> void:
	hp -= amount
	if hp <= 0:
		die()

func die() -> void:
	queue_free()
