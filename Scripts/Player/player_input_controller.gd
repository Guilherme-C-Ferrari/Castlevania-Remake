extends Node

@onready var player: CharacterBody2D = get_parent()

const STAIR_UP := "up"
const STAIR_DOWN := "down"

func _physics_process(_delta: float) -> void:
	get_inputs()
	handle_stairs_input(player)

func get_inputs():
	if player.player_can_control:
		player.jump_pressed = Input.is_action_just_pressed("jump")
		player.move_pressed = Input.get_axis("move_left", "move_right")
		player.duck_pressed = Input.is_action_pressed("descend_stair")
		player.attack_pressed = Input.is_action_just_pressed("attack")
		player.upgrade_wip = Input.is_action_just_pressed("upgrade")
		
	player.descend_pressed = Input.is_action_pressed("descend_stair")
	player.ascend_pressed = Input.is_action_pressed("ascend_stair")
		
func handle_stairs_input(player):
	var stair_controller = player.player_stair_controller
	
	var is_using_stair = stair_controller.check_input()
	
	if is_using_stair:
		if Input.is_action_just_pressed("move_right"):
			stair_controller.use_stair(STAIR_UP)
		elif Input.is_action_just_pressed("move_left"):
			stair_controller.use_stair(STAIR_DOWN)	
	if player.ascend_pressed:
		stair_controller.use_stair(STAIR_UP)
	elif player.descend_pressed:
		stair_controller.use_stair(STAIR_DOWN)
	elif stair_controller.is_on_stair_area:
		stair_controller.not_using_stair()
