@tool
extends BaseSpawner
class_name LongSpawner

@onready var collision_shape: CollisionShape2D
@onready var timer: Timer = $Timer
@export var zone_size: Vector2:
	set(value):
		zone_size = value
		collision_shape = $CollisionShape2D
		collision_shape.shape = collision_shape.shape.duplicate()
		collision_shape.shape.size = value
var player_inside: bool = false
var is_spawning: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	timer.timeout.connect(verify_spawn)

func _physics_process(_delta: float) -> void:
	spawned_enemies = spawned_enemies.filter(func(enemy): return is_instance_valid(enemy))

func verify_spawn() -> void:
	if is_spawning:
		return
	if not player_inside or spawned_enemies.size() >= max_qty_to_spawn:
		return	
	is_spawning = true
	var camera = get_viewport().get_camera_2d()
	if not camera: return
	var camera_center = camera.get_screen_center_position()
	var half_screen = get_viewport_rect().size.x / 2.0
	var min_spawn_x = global_position.x - (zone_size.x / 2.0)
	var max_spawn_x = global_position.x + (zone_size.x / 2.0)
	
	for i in range(max_qty_to_spawn-spawned_enemies.size()):
		while(true):
			var spawn_x = randf_range(min_spawn_x, max_spawn_x)
			if abs(spawn_x - camera_center.x) > (half_screen + 50.0) and abs(spawn_x - camera_center.x) < (half_screen + 70.0):
				spawn_mob_random_pos(spawn_x)
				break
		await get_tree().create_timer(0.5).timeout
	is_spawning = false

func spawn_mob_random_pos(spawn_x: float) -> void:
	if not enemy_to_spawn:
		return
	var enemy = enemy_to_spawn.instantiate()
	enemy.global_position = Vector2(spawn_x, global_position.y)
	
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var direction = sign(player.global_position.x - spawn_x)
		enemy.walk_direction = direction
	get_parent().add_child(enemy)
	spawned_enemies.append(enemy)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = true
	spawn_on_enter()

func spawn_on_enter():
	await get_tree().process_frame
	verify_spawn()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = false
