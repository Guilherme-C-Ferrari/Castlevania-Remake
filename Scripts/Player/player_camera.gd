extends Camera2D

@onready var y_offset := 16

var can_follow_player: bool = false
var current_player_node: CharacterBody2D

func _ready() -> void:
	SignalManager.level_loaded.connect(update_camera_limits)
	if current_player_node:
		can_follow_player = true

func new_scene_loaded(new_tilemap: TileMapLayer, new_player: CharacterBody2D):
	update_camera_limits(new_tilemap)
	update_player_node(new_player)

func update_player_node(new_player):
	current_player_node = new_player
	can_follow_player = true

func _physics_process(delta: float) -> void:
	if can_follow_player:
		print("seguindo player")
		self.position = current_player_node.position

func update_camera_limits(new_tilemap: TileMapLayer):
	#var nodes = get_tree().get_nodes_in_group("tilemap")
	#if nodes.size() > 0:
		#
		#tile_map = nodes[0] as TileMapLayer
		 # 1. Pega o retângulo com as bordas do tilemap
	var map_rect: Rect2 = new_tilemap.get_used_rect()
	# 2. Pega o tamanho de cada tile individual
	var tile_size: Vector2 = new_tilemap.tile_set.tile_size

	# 3. Define os limites da câmera
	limit_left = int(map_rect.position.x * tile_size.x)
	limit_top = y_offset + int(map_rect.position.y * tile_size.y)
	limit_right = int(map_rect.position.x + map_rect.size.x) * int(tile_size.x)
	limit_bottom = y_offset + int(map_rect.position.y + map_rect.size.y) * int(tile_size.y)
	print("L" + str(limit_left))
	print("T" + str(limit_top))
	print("R" + str(limit_right))
	print("B" + str(limit_bottom))

#func update_camera_limits():
	#var nodes = get_tree().get_nodes_in_group("tilemap")
	#if nodes.size() > 0:
		#
		#tile_map = nodes[0] as TileMapLayer
		 ## 1. Pega o retângulo com as bordas do tilemap
		#var map_rect: Rect2 = tile_map.get_used_rect()
		## 2. Pega o tamanho de cada tile individual
		#var tile_size: Vector2 = tile_map.tile_set.tile_size
	#
		## 3. Define os limites da câmera
		#limit_left = int(map_rect.position.x * tile_size.x)
		#limit_top = y_offset + int(map_rect.position.y * tile_size.y)
		#limit_right = int(map_rect.position.x + map_rect.size.x) * int(tile_size.x)
		#limit_bottom = y_offset + int(map_rect.position.y + map_rect.size.y) * int(tile_size.y)
		#
	#else:
		#print("No tilemap found to update camera limits")
