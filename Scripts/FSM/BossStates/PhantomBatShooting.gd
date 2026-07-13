extends EnemyState
class_name PhantomBatShooting

@export var fireball_scene: PackedScene =  preload("uid://c434fca3vnqau")
@onready var shoot_timer: float = 0.6

func enter() -> void:
	shoot_timer = 0.6
	if animated_sprite:
		if not animated_sprite.is_playing() or animated_sprite.animation != "Fighting":
			animated_sprite.play("Fighting") 
	shoot_fireball()

func physics_update(delta: float) -> void:
	if character:
		character.velocity = character.velocity.lerp(Vector2.ZERO, 8.0 * delta)
		character.move_and_slide()
		
	shoot_timer -= delta
	if shoot_timer <= 0:
		transitioned.emit(self, "PhantomBatMenancing")

func shoot_fireball() -> void:
	if not fireball_scene or not character: return
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var fireball = fireball_scene.instantiate()
		fireball.global_position = character.global_position
		character.get_parent().add_child(fireball)
		fireball.start_tween_trajectory(player.global_position)
