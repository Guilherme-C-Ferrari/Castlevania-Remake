extends Area2D

@export var splash_effect_scene: PackedScene = preload("uid://dvaaatdwwiuth")
@export var splash_sound_enter: AudioStream = preload("uid://dl6fonuteh724")
@export var splash_sound_out: AudioStream = preload("uid://f8lch01mpcj2")

@export var water_damage: int = 2

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if "velocity" in body:
		if body.velocity.y > 0.0:
			spawn_splash(body.global_position)
			AudioManager.play_sound_effect(splash_sound_enter, "SFX", -12, 0.85)
			if body.is_in_group("player"):
				await get_tree().create_timer(0.5).timeout
				body.death()

func _on_body_exited(body: Node2D) -> void:
	if "velocity" in body:
		if body.velocity.y < 0.0:
			spawn_splash(body.global_position)
			AudioManager.play_sound_effect(splash_sound_out, "SFX", -12, 0.85)

func spawn_splash(pos: Vector2) -> void:
	if not splash_effect_scene: return
	var splash = splash_effect_scene.instantiate()
	splash.global_position = pos
	get_parent().add_child(splash)
