extends Resource
class_name Weapon_Controller

func weapon_collected(name: String, heart_cost: int, item_sprite: Texture):
	Ui.set_current_weapon(name, heart_cost, item_sprite)
