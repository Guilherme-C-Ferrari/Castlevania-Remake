extends Node

func receive_damage(damage: int):
	Ui.remove_player_health(damage)
