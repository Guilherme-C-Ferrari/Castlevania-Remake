extends CharacterBody2D
class_name BaseEnemy

@export var hp: int
@export var experience: int
@export var damage: int
@export var walk_direction: float
@export var move_speed: float

@onready var already_shown: bool = false
@onready var hit_box: Area2D = $HitBox
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

const fire_explosion = preload("res://Scenes/Effect/fire_explosion.tscn")

func _ready() -> void:
	hit_box.body_entered.connect(_on_player_damaged)

func _physics_process(_delta: float) -> void:
	# verify_despawn()
	update_direction()
	
func verify_despawn() -> void:
	var camera = get_viewport().get_camera_2d()
	if not camera:
		return
	
	var camera_center = camera.get_screen_center_position()
	var screen_width = get_viewport().get_visible_rect().size.x
	var max_distance = (screen_width / 2.0) + 100
	
	if abs(global_position.x - camera_center.x) > max_distance:
		queue_free()

func update_direction() -> void:
	if velocity.x > 0.0:
		walk_direction = 1.0
	elif velocity.x < 0.0:
		walk_direction = -1.0

func _on_player_damaged(_body: Node2D) -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player == _body:
		var stats_controller = player.get_node("Player_Stats_Controller")
		stats_controller.receive_damage(damage)
	else:
		print("Player not found")
	

func on_receive_damage(amount: int) -> void:
	hp -= amount
	if hp <= 0:
		die()

func spawn_explosion() -> void:
	var fire_explosion = fire_explosion.instantiate()
	fire_explosion.global_position = global_position
	get_parent().add_child(fire_explosion)

func die() -> void:
	var ui = get_tree().get_first_node_in_group("UI")
	
	sprite.set_deferred("visible", false)
	hit_box.get_child(0).set_deferred("disabled", true)
	ui.add_score(experience)
	spawn_explosion()
	
	queue_free()
