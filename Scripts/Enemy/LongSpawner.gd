extends BaseSpawner

@export var zone_size: Vector2 = Vector2(400, 100)
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var timer: Timer = $Timer
var player_inside: bool = false

func _ready() -> void:
	if collision_shape and collision_shape.shape is RectangleShape2D:
		collision_shape.shape = collision_shape.shape.duplicate()
		collision_shape.shape.size = zone_size
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	timer.timeout.connect(verify_spawn)
	
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var min_x = global_position.x - (zone_size.x / 2.0)
		var max_x = global_position.x + (zone_size.x / 2.0)
		if player.global_position.x >= min_x and player.global_position.x <= max_x:
			player_inside = true

func _physics_process(_delta: float) -> void:
	spawned_enemies = spawned_enemies.filter(func(enemy): return is_instance_valid(enemy))

func verify_spawn() -> void:
	print(player_inside)
	if not player_inside or spawned_enemies.size() >= max_qty_to_spawn:
		return
	
	var camera = get_viewport().get_camera_2d()
	if not camera: return
	
	var camera_center = camera.get_screen_center_position()
	var half_screen = get_viewport_rect().size.x / 2.0
	var min_spawn_x = global_position.x - (zone_size.x / 2.0)
	var max_spawn_x = global_position.x + (zone_size.x / 2.0)
	
	while(true):
		var target_spawn_x = randf_range(min_spawn_x, max_spawn_x)
		if abs(target_spawn_x - camera_center.x) > (half_screen + 10.0) and abs(target_spawn_x - camera_center.x) < (half_screen + 50.0):
			spawn_mob_random_pos(target_spawn_x)
			break

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
	print("spawn")
	spawned_enemies.append(enemy)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("a")
		player_inside = false
