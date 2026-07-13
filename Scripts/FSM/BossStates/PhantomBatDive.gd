extends EnemyState
class_name PhantomBatDive

@export var dive_speed: float = 100.0 
@export var dive_duration: float = 2.0 

var direction: Vector2 = Vector2.ZERO
var attack_time: float = 0.0

func enter() -> void:
	if animated_sprite:
		if not animated_sprite.is_playing() or animated_sprite.animation != "Fighting":
			animated_sprite.play("Fighting")
	attack_time = dive_duration
	
	var player = get_tree().get_first_node_in_group("player")
	if player:
		direction = (player.global_position - character.global_position).normalized()
	else:
		direction = Vector2(1, 1).normalized()

func physics_update(delta: float) -> void:
	if not character: return
	
	character.velocity = direction * dive_speed
	var collide = character.move_and_slide()
	
	if collide and character.get_slide_collision_count() > 0:
		var collision = character.get_slide_collision(0)
		var normal = collision.get_normal()
		
		direction = direction.bounce(normal).normalized()

	attack_time -= delta
	if attack_time <= 0:
		transitioned.emit(self, "PhantomBatMenancing")
