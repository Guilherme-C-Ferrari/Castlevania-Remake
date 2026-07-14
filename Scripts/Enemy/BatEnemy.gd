extends BaseEnemy

@export var detection_range : float = 300.0
@export var flying_frequency : float = 5.0
@export var flying_amplitude: float = 40.0

func _ready() -> void:
	super()
	hp = 1
	experience = 200
	damage = 2
	move_speed = 75
	if hit_box:
		hit_box.body_entered.connect(_on_hitbox_body_entered)

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		bat_struck()

func bat_struck() -> void:
	AudioManager.play_sound_effect(enemy_destroyer, "SFX", -12, 0.85)
	sprite.set_deferred("visible", false)
	hit_box.get_child(0).set_deferred("disabled", true)
	Ui.add_score(experience)
	spawn_explosion()
	queue_free()
