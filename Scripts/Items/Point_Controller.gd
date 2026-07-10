extends Resource
class_name Point_Controller

const POINTS_EFFECT = preload("uid://qxalx7oayn35")
const Point_400 = preload("uid://btyvjxwwkrbtv")
const Point_700 = preload("uid://dguyc2xdcs35s")
const Point_1000 = preload("uid://bo02o7brpu1ku")

func point_collected(points : int, item_position: Vector2):
	Ui.add_score(points)
	
	var current_scene = Engine.get_main_loop().current_scene
	var effect_instance = POINTS_EFFECT.instantiate()
	
	effect_instance.global_position = item_position
	
	var player = Engine.get_main_loop().get_first_node_in_group("player")
	if player:
		effect_instance.global_position = Vector2(item_position.x, player.global_position.y - 20)
	else:
		effect_instance.global_position = item_position
	
	if points == 400:
		effect_instance.texture = Point_400
	elif points == 700:
		effect_instance.texture = Point_700
	else:
		effect_instance.texture = Point_1000
		
	effect_instance.emitting = true
		
	current_scene.add_child(effect_instance)
	effect_instance.finished.connect(destroy_point_effect.bind(effect_instance))

func destroy_point_effect(effect):
	if is_instance_valid(effect):
		effect.queue_free()
