extends Node

@onready var player = get_tree().get_first_node_in_group("player")

func receive_damage(damage: int, facing: int):
	var enemy_facing := Vector2(facing,0)
	
	if player:
		player.take_hit(enemy_facing)
		
	Ui.remove_player_health(damage)

func remove_player_life():
	Ui.remove_player_life(1)
