extends Node



func item_collected(name: String, heart_cost: int, points:int, item_type: Weapon.Type_Item, item_sprite: Texture):
	
	if Weapon.Type_Item.WEAPON == item_type:
		print("WEAPON COLLECTED")
		
	elif Weapon.Type_Item.POINTS == item_type:
		print("POINTS COLLECTED")
		
	elif Weapon.Type_Item.HEART == item_type:
		print("HEART COLLECTED")
		
	elif Weapon.Type_Item.HEAL == item_type:
		print("HEAL COLLECTED")
		
	elif Weapon.Type_Item.SPECIAL == item_type:
		print("SPECIAL COLLECTED")
