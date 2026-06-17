extends Node2D

var wip_damage := 1

func wip_apply_damage(body: Node2D):
	print("DAR DANO")
	
	if body.is_in_group("enemy") and body.has_method("on_receive_damage"):
		body.on_receive_damage(wip_damage)
		
	elif  body.is_in_group("Item"):
		pass
