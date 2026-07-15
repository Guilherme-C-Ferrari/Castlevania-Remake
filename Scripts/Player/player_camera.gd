extends Camera2D

@onready var y_offset := 16

var can_follow_player: bool = false
var current_player_node: CharacterBody2D

func _ready() -> void:
	SignalManager.disable_camera_follow.connect(turn_off_follow)
	SignalManager.level_loaded.connect(update_camera_limits)
	if current_player_node:
		can_follow_player = true

func turn_off_follow():
	can_follow_player = false

func new_scene_loaded(new_tilemap: TileMapLayer, new_player: CharacterBody2D):
	update_camera_limits(new_tilemap)
	update_player_node(new_player)

func update_player_node(new_player):
	current_player_node = new_player
	can_follow_player = true

func move_camera_to_right(amount: float):
	var tween = create_tween()
	tween.tween_property(self, "position", (self.position + Vector2(amount, 0)), 2)

func _physics_process(_delta: float) -> void:
	if current_player_node and can_follow_player:
		self.position = current_player_node.position

func increase_camera_limit_right(amount: float):
	limit_right += int(amount)

func update_camera_limits(new_tilemap: TileMapLayer):
	# 1. Pega o retângulo com as bordas do tilemap
	var map_rect: Rect2 = new_tilemap.get_used_rect()
	# 2. Pega o tamanho de cada tile individual
	var tile_size: Vector2 = new_tilemap.tile_set.tile_size
	# 3. Define os limites da câmera
	limit_left = int((map_rect.position.x) * tile_size.x + new_tilemap.global_position.x)
	limit_top = y_offset + int(map_rect.position.y * tile_size.y + new_tilemap.global_position.y)
	limit_right = int(map_rect.position.x + map_rect.size.x) * int(tile_size.x) + int(new_tilemap.global_position.x)
	limit_bottom = int(map_rect.position.y + map_rect.size.y) * int(tile_size.y) + int(new_tilemap.global_position.y)

func free_limits():
	limit_left = -9999999999
	limit_top = -9999999999
	limit_right = 9999999999
	limit_bottom = 9999999999
