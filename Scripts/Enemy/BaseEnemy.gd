extends CharacterBody2D
class_name BaseEnemy

@export var hp: int
@export var experience: int
@export var damage: int
@export var walk_direction: Vector2
@export var move_speed: float
@onready var hit_box: Area2D
@onready var already_shown: bool = false

signal player_damaged(damage: int)

func _ready() -> void:
	hit_box.body_entered.connect(_on_player_damaged)

func _physics_process(delta: float) -> void:
	verify_despawn()
	
func verify_despawn() -> void:
	var camera = get_viewport().get_camera_2d()
	if not camera:
		return
	
	var camera_center = camera.get_screen_center_position()
	var screen_width = get_viewport().get_visible_rect().size.x
	var max_distance = (screen_width / 2.0) + 100
	
	if abs(global_position.x - camera_center.x) > max_distance:
		queue_free()

func _on_player_damaged(_body: Node2D) -> void:
	player_damaged.emit(damage)

func on_receive_damage(amount: int) -> void:
	hp -= amount
	if hp <= 0:
		die()

func die() -> void:
	queue_free()
