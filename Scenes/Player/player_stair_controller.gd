extends Node

enum StairSide {
	LEFT,
	RIGHT
}

@onready var player: CharacterBody2D = get_parent()

const STAIR_UP := "up"
const STAIR_DOWN := "down"

@export var stair_side: StairSide = StairSide.RIGHT

# referência da escada atual
var current_stair: Stair = null

# pontos da escada (futuro uso)
var current_point := -1
var target_point := -1

# movimento até entrada da escada
var target_position := Vector2.ZERO

var is_on_stair := false
var is_using_stair := false

var stair_mode := ""


func enter_stair(
	stair: Stair,
	stair_side_area: StairSide,
	stair_direction: String,
	area_position: Vector2
) -> void:

	current_stair = stair
	stair_side = stair_side_area
	stair_mode = stair_direction

	target_position = area_position

	is_on_stair = true
	is_using_stair = false

	current_point = -1
	target_point = -1


func exit_stair() -> void:
	current_stair = null

	is_on_stair = false
	is_using_stair = false

	current_point = -1
	target_point = -1

	player.player_can_control = true


func use_stair(stair_direction: String) -> void:
	if !is_on_stair:
		return

	if stair_mode != stair_direction:
		return

	is_using_stair = true
	player.player_can_control = false


func handle_stairs(delta: float) -> bool:
	if !is_using_stair:
		return false

	player.is_walking = true
	player.velocity = Vector2.ZERO

	var direction = sign(target_position.x - player.global_position.x)

	if direction != 0:
		player.visual.scale.x = -direction
		player.player_combat_controller.scale.x = -direction

	player.global_position = player.global_position.move_toward(
		target_position,
		58.0 * delta
	)

	if player.global_position.distance_to(target_position) < 2.0:

		player.global_position = target_position

		is_using_stair = false

		# chegou na base da escada -> prepara próxima fase
		current_point = get_start_point_index()

		player.player_can_control = true
		player.is_walking = false

		apply_facing_fix()

	return true


func get_start_point_index() -> int:
	if stair_mode == STAIR_UP:
		return 0
	else:
		return current_stair.get_step_count() - 1


func apply_facing_fix():
	if stair_side == StairSide.RIGHT:
		player.visual.scale.x = -1 if stair_mode == STAIR_UP else 1
	else:
		player.visual.scale.x = 1 if stair_mode == STAIR_UP else -1

	player.player_combat_controller.scale.x = player.visual.scale.x


func not_using_stair():
	is_using_stair = false
	player.player_can_control = true
