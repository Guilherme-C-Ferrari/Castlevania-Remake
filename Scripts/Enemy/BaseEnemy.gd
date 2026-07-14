extends CharacterBody2D
class_name BaseEnemy

@export var hp: int
@export var experience: int
@export var damage: int
@export var walk_direction: float
@export var move_speed: float

@onready var hit_box: Area2D = $HitBox
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var is_on_screen: bool = false
@onready var is_time_stopped: bool = false
@onready var saved_move_speed : float = 0.0

const enemy_destroyer = preload("res://Audio/SFX/32. SFX - Enemy - Candle Destroyer.mp3")
const fire_explosion = preload("res://Scenes/Effect/fire_explosion.tscn")

const ITEM_DROP_SCENE = preload("res://Scenes/Environment/item_drop.tscn")
const HEART_RES = preload("res://Scripts/Items/Hearts/heart.tres")
const WIP_UPGRADE = preload("res://Scripts/Items/Wip/wip_upgrade.tres")
const BAG_400_RES = preload("res://Scripts/Items/Point/bag_400.tres")
const BAG_700_RES = preload("res://Scripts/Items/Point/bag_700.tres")
const AXE_RES = preload("res://Scripts/Items/Weapons/axe.tres")
const DAGGER_RES = preload("res://Scripts/Items/Weapons/dagger.tres")
const WATCH_RES = preload("res://Scripts/Items/Weapons/watch.tres")
const WATER_RES = preload("res://Scripts/Items/Weapons/water.tres")

func _ready() -> void:
	hit_box.body_entered.connect(_on_player_damaged)

func _physics_process(_delta: float) -> void:
	verify_despawn()
	update_direction()
	
func verify_despawn() -> void:
	var camera = get_viewport().get_camera_2d()
	if not camera:
		return
	
	var camera_center = camera.get_screen_center_position()
	var screen_width = get_viewport().get_visible_rect().size.x
	var max_distance = (screen_width / 2.0) + 100
	
	if (abs(global_position.x - camera_center.x) < screen_width/2):
		is_on_screen = true
	else:
		is_on_screen = false
	
	if (abs(global_position.x - camera_center.x) > max_distance) or (abs(global_position.y - camera_center.y) > max_distance):
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
		stats_controller.receive_damage(damage, walk_direction)
	else:
		print("Player not found")

func on_receive_damage(amount: int) -> void:
	hp -= amount
	if hp <= 0:
		die()

func spawn_explosion() -> void:
	var explosion = fire_explosion.instantiate()
	explosion.global_position = sprite.global_position
	get_parent().add_child(explosion)

func stop_time() -> void:
	if is_time_stopped: 
		return
	is_time_stopped = true
	saved_move_speed  = move_speed 
	move_speed  = 0.0

	if sprite:
		sprite.pause()

func resume_time() -> void:
	if not is_time_stopped: 
		return
	is_time_stopped = false
	move_speed = saved_move_speed
	
	if sprite:
		sprite.play()

func drop_item() -> void:
	var roll = randf()
	if roll < 0.70:
		return 
	elif roll < 0.85:
		drop_heart() 
	elif roll < 0.95:
		drop_money()
	else:
		drop_weapon()

func drop_heart() -> void:
	if Ui.wip_level != 3 and randf() < 0.8:
		spawn_drop(WIP_UPGRADE)
	else:
		spawn_drop(HEART_RES)

func drop_money() -> void:
	var money_roll = randf()
	if money_roll > 0.80:
		spawn_drop(BAG_700_RES)
	else:
		spawn_drop(BAG_400_RES)

func drop_weapon() -> void:
	var weapon_roll = randf()
	if weapon_roll > 0.75:
		pass
		#spawn_drop(WATER_RES)   
	elif weapon_roll > 0.50:
		spawn_drop(WATCH_RES)   
	elif weapon_roll > 0.25:
		spawn_drop(DAGGER_RES)  
	else:
		spawn_drop(AXE_RES) 

func spawn_drop(item_resource: Resource) -> void:
	if not item_resource or not ITEM_DROP_SCENE: return
	var drop_instance = ITEM_DROP_SCENE.instantiate()
	if "item_resource" in drop_instance:
		drop_instance.item_resource = item_resource
	drop_instance.global_position = Vector2(global_position.x , global_position.y - 16)
	get_parent().add_child(drop_instance)

func die() -> void:
	AudioManager.play_sound_effect(enemy_destroyer, "SFX", -12, 0.85)
	sprite.set_deferred("visible", false)
	hit_box.get_child(0).set_deferred("disabled", true)
	Ui.add_score(experience)
	spawn_explosion()
	drop_item()
	queue_free()
