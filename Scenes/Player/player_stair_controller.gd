extends Node

@onready var player: CharacterBody2D = get_parent()

var target_position := Vector2.ZERO
var is_on_stair := false
var is_using_stair := false
var stair_mode := ""

func _physics_process(delta: float) -> void:
	handle_stairs(delta)

func enter_stair(area_position: Vector2) -> void:
	is_on_stair = true
	target_position = area_position

func exit_stair() -> void:
	is_on_stair = false
	is_using_stair = false
	stair_mode = ""
	player.player_can_control = true
	player.is_walking = false

func try_use_stair_up() -> void:
	if !is_on_stair:
		return

	is_using_stair = true
	stair_mode = "up"
	player.player_can_control = false

func try_use_stair_down() -> void:
	if !is_on_stair:
		return

	is_using_stair = true
	stair_mode = "down"
	player.player_can_control = false

func handle_stairs(delta: float) -> void:
	if !is_using_stair:
		return

	player.is_walking = true
	player.velocity = Vector2.ZERO

	player.global_position = player.global_position.move_toward(
		target_position,
		58.0 * delta
	)

	if player.global_position.distance_to(target_position) < 2.0:
		player.global_position = target_position
		is_using_stair = false
		stair_mode = ""
		player.player_can_control = true
		player.is_walking = false
