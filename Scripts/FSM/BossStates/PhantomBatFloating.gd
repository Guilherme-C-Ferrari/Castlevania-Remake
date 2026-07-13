extends EnemyState
class_name PhantomBatFloating

@export var float_speed: float = 60.0
@export var float_duration: float = 4.0

var player: CharacterBody2D = null
var timer: float = 0.0
var timer_sin: float = 0.0

func enter() -> void:
	player = get_tree().get_first_node_in_group("player")
	if animated_sprite:
		if not animated_sprite.is_playing() or animated_sprite.animation != "Fighting":
			animated_sprite.play("Fighting")
	timer = float_duration

func physics_update(delta: float) -> void:
	if not character: return
	
	timer_sin += delta
	if player:
		var wave = sin(timer_sin * 5.0) * 20.0
		var target_pos = Vector2(player.global_position.x, player.global_position.y - 40.0 + wave)
		
		var direction = (target_pos - character.global_position).normalized()
		character.velocity = direction * float_speed
	
	character.move_and_slide()
	
	timer -= delta
	if timer <= 0:
		transitioned.emit(self, "PhantomBatMenancing")
