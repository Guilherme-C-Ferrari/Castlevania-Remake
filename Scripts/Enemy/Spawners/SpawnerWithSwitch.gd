@tool
extends BaseSpawner
class_name SpawnerWithSwitch

@onready var collision_shape: CollisionShape2D
@onready var timer: Timer = $Timer
@export var zone_size: Vector2:
	set(value):
		zone_size = value
		collision_shape = $CollisionShape2D
		collision_shape.shape = collision_shape.shape.duplicate()
		collision_shape.shape.size = value
var is_on: bool = false
var is_spawning: bool = false

func _ready() -> void:
	turn_spawner_off()
	timer.timeout.connect(verify_spawn)

func _physics_process(_delta: float) -> void:
	spawned_enemies = spawned_enemies.filter(func(enemy): return is_instance_valid(enemy))

func verify_spawn() -> void:
	if spawned_enemies.size() >= max_qty_to_spawn or not is_on:
		return
	
	var camera = get_viewport().get_camera_2d()
	if not camera: return
	
	var screen_size = get_viewport_rect().size
	var camera_rect = Rect2(camera.get_screen_center_position() - (screen_size / 2.0), screen_size)
	var spawner_rect = Rect2(global_position - (zone_size / 2.0), zone_size)
	
	if camera_rect.intersects(spawner_rect):
		var visible_spawn_zone = camera_rect.intersection(spawner_rect)
		for i in range(max_qty_to_spawn-spawned_enemies.size()):
			spawn_mob_in_camera(visible_spawn_zone)
	
func spawn_mob_in_camera(spawn_zone: Rect2) -> void:
	if not enemy_to_spawn:
		return
	var enemy = enemy_to_spawn.instantiate()
	get_parent().add_child(enemy)
	
	var random_x = randf_range(spawn_zone.position.x, spawn_zone.end.x)
	var random_y = randf_range(spawn_zone.position.y, spawn_zone.end.y)
	enemy.global_position = Vector2(random_x, random_y)
	
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var direction = sign(player.global_position.x - global_position.x)
		enemy.walk_direction = direction
	
	spawned_enemies.append(enemy)

func turn_spawner_on() -> void:
	is_on = true
	timer.start()
	set_physics_process(true)

func turn_spawner_off() -> void:
	is_on = false
	timer.stop()
	set_physics_process(false)
