@tool
extends LongSpawner

func verify_spawn() -> void:
	if is_spawning:
		return
	if not player_inside or spawned_enemies.size() >= max_qty_to_spawn:
		return    
	is_spawning = true
	
	var camera = get_viewport().get_camera_2d()
	var player = get_tree().get_first_node_in_group("player")
	if not camera or not player: 
		is_spawning = false
		return
		
	var camera_center = camera.get_screen_center_position()
	var half_screen = get_viewport_rect().size.x / 2.0
	
	for i in range(max_qty_to_spawn - spawned_enemies.size()):
		var side = -1.0 if randf() < 0.5 else 1.0
		var spawn_x = camera_center.x + (side * (half_screen + 50.0))
		var spawn_y = player.global_position.y - 15
		spawn_flying_enemy_pos(spawn_x, spawn_y)
		await get_tree().create_timer(0.5).timeout
	is_spawning = false

func spawn_flying_enemy_pos(spawn_x: float, spawn_y: float) -> void:
	if not enemy_to_spawn:
		return
	var enemy = enemy_to_spawn.instantiate()
	
	# Define a posição inicial com o Y do player
	enemy.global_position = Vector2(spawn_x, spawn_y+5)
	
	var player = get_tree().get_first_node_in_group("player")
	if player:
		# Define a direção olhando para o player (se nasceu na esquerda vai para a direita e vice-versa)
		enemy.walk_direction = sign(player.global_position.x - spawn_x)
		
	get_parent().add_child(enemy)
	spawned_enemies.append(enemy)
