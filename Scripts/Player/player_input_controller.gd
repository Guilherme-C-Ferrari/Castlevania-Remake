extends Node

func get_inputs(player):
	if player.player_can_control:
		player.jump_pressed = Input.is_action_just_pressed("jump")
		player.move_pressed = Input.get_axis("move_left", "move_right")
		player.duck_pressed = Input.is_action_pressed("descend_stair")
		player.ascend_pressed = Input.is_action_pressed("ascend_stair")
		player.descend_pressed = Input.is_action_pressed("descend_stair")
		player.attack_pressed = Input.is_action_just_pressed("attack")
		player.upgrade_wip = Input.is_action_just_pressed("upgrade")

		handle_stairs_input(player)

func handle_stairs_input(player):
	if player.ascend_pressed:
		player.player_stair_controller.try_use_stair_up()

	if player.descend_pressed:
		player.player_stair_controller.try_use_stair_down()
