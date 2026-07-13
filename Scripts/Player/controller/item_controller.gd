extends Node

const WEAPON_OBTAINED_SFX = preload("uid://clswbxpktn0qf")
const ITEM_SFX = preload("uid://0ojubb5rlws2")
const BONUS_SFX = preload("uid://cxy2yireb4m80")

var heart_controller: Heart_Controller
var special_controller: Special_Controller
var point_controller: Point_Controller
var heal_controller: Heal_Controller
var weapon_controller: Weapon_Controller

func _ready() -> void:
	heart_controller = Heart_Controller.new()
	special_controller = Special_Controller.new()
	point_controller = Point_Controller.new()
	heal_controller = Heal_Controller.new()
	weapon_controller = Weapon_Controller.new()

func item_collected(name: String, heart_cost: int, points: int, item_type: Weapon.Type_Item, item_sprite: Texture, item_global_position: Vector2):
	
	#WEAPON
	if Weapon.Type_Item.WEAPON == item_type:
		AudioManager.play_sound_effect(WEAPON_OBTAINED_SFX, "SFX", -12)
		weapon_controller.weapon_collected(name, heart_cost, item_sprite)
	
	#POINTS
	elif Weapon.Type_Item.POINTS == item_type:
		AudioManager.play_sound_effect(BONUS_SFX, "SFX", -12)
		
		if point_controller:
			point_controller.point_collected(points, item_global_position)
		
	#HEART
	elif Weapon.Type_Item.HEART == item_type:
		AudioManager.play_sound_effect(ITEM_SFX, "SFX", -12)
		
		if heart_controller:
			heart_controller.heart_collected(points)
		
	#HEAL
	elif Weapon.Type_Item.HEAL == item_type:
		AudioManager.play_sound_effect(WEAPON_OBTAINED_SFX, "SFX", -12)
		
		if heal_controller:
			heal_controller.heal_collected(name, points)
		
	#SPECIAL
	elif Weapon.Type_Item.SPECIAL == item_type:
		if special_controller:
			special_controller.special_collected(name)
