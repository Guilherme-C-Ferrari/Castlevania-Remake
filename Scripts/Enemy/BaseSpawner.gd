extends Area2D

@export var enemy_to_spawn: PackedScene
@export var max_qty_to_spawn: int
var spawned_enemies: Array = []

func _physics_process(_delta: float) -> void:
	spawned_enemies = spawned_enemies.filter(func(enemy): return is_instance_valid(enemy))
	verify_spawn()

func verify_spawn() -> void:
	if spawned_enemies.size() >= max_qty_to_spawn:
		return
	
	var camera = get_viewport().get_camera_2d()
	if not camera:
		return
	var camera_center = camera.get_screen_center_position()
	var screen_width = get_viewport_rect().size.x
	var spawn_distance = (screen_width / 2.0) + 50
	if abs(global_position.x - camera_center.x) > spawn_distance:
		spawn_mob()

func spawn_mob() -> void:
	if not enemy_to_spawn:
		return
	var enemy = enemy_to_spawn.instantiate()
	
	enemy.global_position = global_position
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var direction = sign(player.global_position.x - global_position.x)
		enemy.walk_direction = direction
	
	get_parent().add_child(enemy)
	spawned_enemies.append(enemy)
