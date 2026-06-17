extends EnemyState
class_name Idling

var player: CharacterBody2D = null

func enter() -> void:
	player = get_tree().get_first_node_in_group("player")
	if animated_sprite:
		if not animated_sprite.is_playing() or animated_sprite.animation != "Idling":
			animated_sprite.play("Idling")

func physics_update(_delta: float) -> void:
	if not character.is_on_floor():
		place_on_ground(_delta)
	
	if player:
		var distance = character.global_position.distance_to(player.global_position)
		if distance <= character.detection_range:
			transitioned.emit(self, "Following")
			return

func place_on_ground(_delta: float) -> void:
	character.velocity += character.get_gravity() * _delta
	character.move_and_slide()
