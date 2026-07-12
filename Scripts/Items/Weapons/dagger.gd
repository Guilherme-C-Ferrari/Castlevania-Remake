extends Area2D

@export var velocity := 5.0


func _process(delta: float) -> void:
	position = Vector2(position.x + (velocity * delta * -scale.x), position.y)
	
func destroy_weapon():
	queue_free()
	Ui.add_weapon_usage()

func _on_body_entered(body: Node2D) -> void:
	if (body.is_in_group("enemy") or body.is_in_group("structure")) and body.has_method("on_receive_damage"):
		destroy_weapon()
		body.on_receive_damage(1)
	elif  body.is_in_group("Item"):
		destroy_weapon()
		pass
		
	
