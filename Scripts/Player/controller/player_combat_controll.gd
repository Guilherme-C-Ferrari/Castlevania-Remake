extends Node2D

var wip_damage := 1

func wip_apply_damage(body: Node2D):
	if (body.is_in_group("enemy") or body.is_in_group("structure")) and body.has_method("on_receive_damage"):
		wip_damage = 1 if Ui.get_player_wip_level()== 1 else 2
		body.on_receive_damage(wip_damage)
	elif  body.is_in_group("Item"):
		pass
