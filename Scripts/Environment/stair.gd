class_name Stair
extends Node2D

enum StairSide {
	LEFT,
	RIGHT
}

const STAIR_UP := "up"
const STAIR_DOWN := "down"

@export var stair_side: StairSide = StairSide.RIGHT

@onready var path_2d: Path2D = $Path2D
@onready var up_area: Area2D = $Up_Area
@onready var down_area: Area2D = $Down_Area

var player: CharacterBody2D = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func get_step_count() -> int:
	return path_2d.curve.point_count

func get_step_position(step: int) -> Vector2:
	step = clamp(step, 0, get_step_count() - 1)

	return path_2d.to_global(path_2d.curve.get_point_position(step))

func _on_up_area_body_entered(body: Node2D) -> void:
	if body != player:
		return

	player.player_stair_controller.enter_stair(
		self,
		stair_side,
		STAIR_UP,
		up_area.global_position
	)

func _on_up_area_body_exited(body: Node2D) -> void:
	if body != player:
		return

	player.player_stair_controller.exit_stair()

func _on_down_area_body_entered(body: Node2D) -> void:
	if body != player:
		return

	player.player_stair_controller.enter_stair(
		self,
		stair_side,
		STAIR_DOWN,
		down_area.global_position
	)

func _on_down_area_body_exited(body: Node2D) -> void:
	if body != player:
		return

	player.player_stair_controller.exit_stair()
