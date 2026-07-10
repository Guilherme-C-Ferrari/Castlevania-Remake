extends Resource
class_name Heal_Controller

func heal_collected(heal_points:int):
	Ui.add_player_health(heal_points)
