extends Node

enum StairSide {
	LEFT,
	RIGHT
}

@onready var player: CharacterBody2D = get_parent()

const STAIR_UP := "up"
const STAIR_DOWN := "down"
const stair_speed := 50

@export var stair_side: StairSide = StairSide.RIGHT

# referência da escada atual
var current_stair: Stair = null

# pontos da escada (futuro uso)
var current_point := -1
var target_point := -1

# movimento até entrada da escada
var target_position := Vector2.ZERO

var is_on_stair_area := false
var is_walking_to_stair := false
var is_using_stair := false 

var stair_mode := ""
var player_input_direction = ""


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

	is_on_stair_area = true
	is_walking_to_stair = false
	is_using_stair = false

	current_point = -1
	target_point = -1
	
	print(stair.get_step_count())
	print(stair.get_step_position(0))


func exit_stair() -> void:
	#current_stair = null

	is_on_stair_area = false
	is_walking_to_stair = false
	#is_using_stair = false

	player.player_can_control = true


func use_stair(input_direction: String) -> void:
	player.is_moving_on_stair = true
	player_input_direction = input_direction
	if !is_on_stair_area:
		return

	if stair_mode != input_direction:
		return
	
	if !is_using_stair:
		is_walking_to_stair = true
		player.player_can_control = false


func handle_stairs(delta: float) -> bool:
	if !is_walking_to_stair and !is_using_stair:
		return false

	if is_walking_to_stair:
		walk_to_stair(delta)
	else:
		using_stair(delta)
	return true

func walk_to_stair(delta: float):
	print("chamando")
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

		
		is_on_stair_area = false
		is_walking_to_stair = false
		is_using_stair = true

		current_point = get_start_point_index()

		player.player_can_control = true
		player.is_walking = false

		apply_facing_fix()

func using_stair(delta: float):
	#print("Usando a escada:" + str(current_point))
	
	var step_position = current_stair.get_step_position(current_point)
	player.global_position = player.global_position.move_toward(
		current_stair.get_step_position(current_point),
		stair_speed * delta
	)
	
	if player.global_position.distance_to(step_position) <= 1.0:
		#print("CHEGOU NO STEP: " + str(current_point))
		player.is_moving_on_stair = false
		if !player.is_attacking:
			if player_input_direction == STAIR_UP:
				player.is_ascending = true
				player.is_descending = false
				stair_mode = STAIR_UP
				current_point += 1
			elif player_input_direction == STAIR_DOWN:
				player.is_ascending = false
				player.is_descending = true
				stair_mode = STAIR_DOWN
				current_point -= 1
		
		apply_facing_fix()
		
	
func get_start_point_index() -> int:
	if stair_mode == STAIR_UP:
		return 0
	else:
		return current_stair.get_step_count() - 1


func apply_facing_fix():
	if stair_side == StairSide.RIGHT:
		player.turn_player("RIGHT") if stair_mode == STAIR_UP else player.turn_player("LEFT")
	else:
		player.turn_player("LEFT") if stair_mode == STAIR_UP else player.turn_player("RIGHT")


#SUBIR - DIREITA = direita
#DESCER - DIREITA = esquerda
#SUBIR - ESQUERDA = esquerda
#DESCER - ESQUERDA = direita
func check_input() -> bool:
	player_input_direction = ""
	if is_using_stair:
		return true
	
	player.is_ascending = false
	player.is_descending = false
	return false
	
func not_using_stair():
	player_input_direction = ""
	is_walking_to_stair = false
	is_using_stair = false
	player.player_can_control = true
	player.is_ascending = false
	player.is_descending = false
	player.is_moving_on_stair = false
