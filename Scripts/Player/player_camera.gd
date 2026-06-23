extends Camera2D

@onready var y_offset := 16

var tile_map: TileMapLayer

func _ready() -> void:
	update_camera_limits()

func update_camera_limits():
	var nodes = get_tree().get_nodes_in_group("tilemap")
	if nodes.size() > 0:
		
		tile_map = nodes[0] as TileMapLayer
		 # 1. Pega o retângulo com as bordas do tilemap
		var map_rect: Rect2 = tile_map.get_used_rect()
		# 2. Pega o tamanho de cada tile individual
		var tile_size: Vector2 = tile_map.tile_set.tile_size
	
		# 3. Define os limites da câmera
		limit_left = int(map_rect.position.x * tile_size.x)
		limit_top = y_offset + int(map_rect.position.y * tile_size.y)
		limit_right = int(map_rect.position.x + map_rect.size.x) * int(tile_size.x)
		limit_bottom = y_offset + int(map_rect.position.y + map_rect.size.y) * int(tile_size.y)
		
	else:
		print("No tilemap found to update camera limits")
