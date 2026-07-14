extends BaseEnemy
class_name BaseBoss

@onready var is_active : bool = false

func _ready() -> void:
	super()

func _physics_process(_delta: float) -> void:
	update_direction()

func activate() -> void:
	is_active = true

func on_receive_damage(amount: int) -> void:
	AudioManager.play_sound_effect(enemy_destroyer, "SFX", -12, 0.85)
	spawn_explosion()
	hp -= amount
	Ui.remove_enemy_health(amount)
	if hp <= 0:
		die()

func drop_item() -> void:
	pass
