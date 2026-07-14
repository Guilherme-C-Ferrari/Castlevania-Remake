extends EnemyState
class_name PhantomBatFloating

@export var float_speed: float = 80.0
@export var float_duration: float = 2.5

var player: CharacterBody2D = null
var timer: float = 0.0
var target_direction: float = 1.0

func enter() -> void:
	player = get_tree().get_first_node_in_group("player")
	if animated_sprite:
		if not animated_sprite.is_playing() or animated_sprite.animation != "Fighting":
			animated_sprite.play("Fighting")
	if player and character:
		target_direction = sign(player.global_position.x - character.global_position.x)
		character.walk_direction = target_direction
	timer = float_duration

func physics_update(delta: float) -> void:
	if not character: return

	character.velocity.x = target_direction * float_speed
	character.velocity.y = -20.0
	character.move_and_slide()
	
	timer -= delta
	if timer <= 0:
		transitioned.emit(self, "PhantomBatMenancing")
