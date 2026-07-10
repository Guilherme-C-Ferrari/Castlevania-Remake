@tool
class_name Stair
extends Node2D

enum StairSide {
	LEFT,
	RIGHT
}

const STAIR_UP := "up"
const STAIR_DOWN := "down"

@export_group("Stair Settings")
@export var stair_side: StairSide = StairSide.RIGHT:
	set(value):
		stair_side = value
		_update_stair()

@export_range(2, 100) var step_count: int = 8:
	set(value):
		step_count = value
		_update_stair()

@export_group("Collision Settings")
@export var up_area_size: Vector2 = Vector2(16, 16):
	set(value):
		up_area_size = value
		_update_collision_sizes()

@export var up_area_offset_x: float = 0.0:
	set(value):
		up_area_offset_x = value
		_update_collision_sizes()

@export var down_area_size: Vector2 = Vector2(16, 16):
	set(value):
		down_area_size = value
		_update_collision_sizes()

@export var down_area_offset_x: float = 0.0:
	set(value):
		down_area_offset_x = value
		_update_collision_sizes()

@onready var path_2d: Path2D = $Path2D
@onready var up_area: Area2D = $Up_Area
@onready var down_area: Area2D = $Down_Area

var player: CharacterBody2D = null

func _ready() -> void:
	_update_stair()
	SignalManager.player_spawned.connect(update_player_reference)
	
	if not Engine.is_editor_hint():
		player = get_tree().get_first_node_in_group("player")
		_connect_signals_automatically()

func update_player_reference(new_player: CharacterBody2D):
	player = new_player

func _connect_signals_automatically() -> void:
	if up_area and not up_area.body_entered.is_connected(_on_up_area_body_entered):
		up_area.body_entered.connect(_on_up_area_body_entered)
	if up_area and not up_area.body_exited.is_connected(_on_up_area_body_exited):
		up_area.body_exited.connect(_on_up_area_body_exited)
		
	if down_area and not down_area.body_entered.is_connected(_on_down_area_body_entered):
		down_area.body_entered.connect(_on_down_area_body_entered)
	if down_area and not down_area.body_exited.is_connected(_on_down_area_body_exited):
		down_area.body_exited.connect(_on_down_area_body_exited)

func _update_stair() -> void:
	if not path_2d:
		return
		
	var new_curve := Curve2D.new()
	var dir_x = 1.0 if stair_side == StairSide.RIGHT else -1.0
	
	new_curve.add_point(Vector2.ZERO)
	
	var current_pos = Vector2.ZERO
	for i in range(1, step_count + 1):
		if i == 1:
			current_pos += Vector2(5.0 * dir_x, -9.0)
		elif i == step_count:
			current_pos += Vector2(12.0 * dir_x, -8.0)
		else:
			current_pos += Vector2(8.0 * dir_x, -8.0)
			
		new_curve.add_point(current_pos)
		
	path_2d.curve = new_curve
	_update_area_positions(current_pos)

func _update_collision_sizes() -> void:
	if not is_inside_tree():
		return
		
	if up_area and up_area.has_node("CollisionShape2D"):
		var col_shape = up_area.get_node("CollisionShape2D")
		if not col_shape.shape or not col_shape.shape.is_local_to_scene():
			col_shape.shape = RectangleShape2D.new()
		
		var shape = col_shape.shape
		if shape is RectangleShape2D:
			shape.size = up_area_size
			col_shape.position.x = up_area_offset_x
			
	if down_area and down_area.has_node("CollisionShape2D"):
		var col_shape = down_area.get_node("CollisionShape2D")
		if not col_shape.shape or not col_shape.shape.is_local_to_scene():
			col_shape.shape = RectangleShape2D.new()
			
		var shape = col_shape.shape
		if shape is RectangleShape2D:
			shape.size = down_area_size
			col_shape.position.x = down_area_offset_x

func _update_area_positions(top_position: Vector2) -> void:
	if up_area:
		up_area.position = Vector2.ZERO
	if down_area:
		down_area.position = top_position
	_update_collision_sizes()

func get_step_count() -> int:
	if not path_2d or not path_2d.curve:
		return 0
	return path_2d.curve.point_count

func get_step_position(step: int) -> Vector2:
	step = clamp(step, 0, get_step_count() - 1)
	return path_2d.to_global(path_2d.curve.get_point_position(step))

func _on_up_area_body_entered(body: Node2D) -> void:
	if Engine.is_editor_hint() or body != player:
		return

	player.player_stair_controller.enter_stair(
		self,
		stair_side,
		STAIR_UP,
		up_area.global_position
	)

func _on_up_area_body_exited(body: Node2D) -> void:
	if Engine.is_editor_hint() or body != player:
		return

	player.player_stair_controller.exit_stair(self)

func _on_down_area_body_entered(body: Node2D) -> void:
	if Engine.is_editor_hint() or body != player:
		return

	player.player_stair_controller.enter_stair(
		self,
		stair_side,
		STAIR_DOWN,
		down_area.global_position
	)

func _on_down_area_body_exited(body: Node2D) -> void:
	if Engine.is_editor_hint() or body != player:
		return
	player.player_stair_controller.exit_stair(self)
