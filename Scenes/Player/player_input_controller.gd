extends Node

@onready var player: CharacterBody2D = get_parent()

func _physics_process(_delta: float) -> void:
	get_inputs()

func get_inputs():
	if player.player_can_control:
		player.jump_pressed = Input.is_action_just_pressed("jump")
		player.move_pressed = Input.get_axis("move_left", "move_right")
		player.duck_pressed = Input.is_action_pressed("descend_stair")
		player.descend_pressed = Input.is_action_pressed("descend_stair")
		player.ascend_pressed = Input.is_action_pressed("ascend_stair")
		player.attack_pressed = Input.is_action_just_pressed("attack")
		player.upgrade_wip = Input.is_action_just_pressed("upgrade")
