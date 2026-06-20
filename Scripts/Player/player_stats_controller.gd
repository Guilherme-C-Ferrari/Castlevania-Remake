extends Node

func receive_damage(damage: int):
	var ui = get_tree().get_first_node_in_group("UI")
	ui.remove_player_health(damage)
