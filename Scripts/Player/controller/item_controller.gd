extends Node

const WEAPON_OBTAINED_SFX = preload("uid://clswbxpktn0qf")
const ITEM_SFX = preload("uid://0ojubb5rlws2")
const BONUS_SFX = preload("uid://cxy2yireb4m80")

var heart_controller: Heart_Controller
var special_contrller: Special_Controller
func _ready() -> void:
	heart_controller = Heart_Controller.new()
	special_contrller = Special_Controller.new()

func item_collected(name: String, heart_cost: int, points: int, item_type: Weapon.Type_Item, item_sprite: Texture):
	
	if Weapon.Type_Item.WEAPON == item_type:
		AudioManager.play_sound_effect(WEAPON_OBTAINED_SFX, "SFX", -12)
		print("WEAPON COLLECTED")
		
	elif Weapon.Type_Item.POINTS == item_type:
		AudioManager.play_sound_effect(BONUS_SFX, "SFX", -12)
		print("POINTS COLLECTED")
		
	elif Weapon.Type_Item.HEART == item_type:
		print("HEART COLLECTED")
		AudioManager.play_sound_effect(ITEM_SFX, "SFX", -12)
		
		if heart_controller:
			heart_controller.heart_collected(points)
		
	elif Weapon.Type_Item.HEAL == item_type:
		AudioManager.play_sound_effect(WEAPON_OBTAINED_SFX, "SFX", -12)
		print("HEAL COLLECTED")
		
	elif Weapon.Type_Item.SPECIAL == item_type:
		print("SPECIAL COLLECTED")
		if special_contrller:
			special_contrller.special_collected(name)
