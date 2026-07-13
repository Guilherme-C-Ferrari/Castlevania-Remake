extends EnemyState
class_name PhantomBatMenancing

@export var rest_time: float = 5.0
@export var target_y: float = 170.0 
@export var camera_margin_left: float = 40.0
@export var camera_margin_right: float = 40.0

var target_x: float = 0.0
var timer: float = 0.0

func enter() -> void:
	if animated_sprite:
		if not animated_sprite.is_playing() or animated_sprite.animation != "Fighting":
			animated_sprite.play("Fighting")
	timer = rest_time
	
	var camera = get_viewport().get_camera_2d()
	if camera:
		var camera_left = camera.get_screen_center_position().x - (get_viewport().get_visible_rect().size.x / 2.0)
		var camera_right = camera_left + get_viewport().get_visible_rect().size.x
		target_x = randf_range(camera_left + camera_margin_left, camera_right - camera_margin_right)
	else:
		target_x = character.global_position.x

func physics_update(delta: float) -> void:
	if not character: return
	
	var next_x = lerp(character.global_position.x, target_x, 5 * delta)
	character.velocity.x = (next_x - character.global_position.x) * 8.0
	
	var next_y = lerp(character.global_position.y, target_y, 5 * delta)
	character.velocity.y = (next_y - character.global_position.y) * 8.0
	
	character.move_and_slide()
	
	timer -= delta
	if timer <= 0:
		choose_next_state()

func choose_next_state() -> void:
	# var roll = randf()
	transitioned.emit(self, "PhantomBatDive")
	#if roll < 0.50:       
	#	transitioned.emit(self, "PhantomBatDive")
	#elif roll < 0.80:      
	#	transitioned.emit(self, "PhantomBatFloating")
	#else:                  
	#	transitioned.emit(self, "PhantomBatShooting")
