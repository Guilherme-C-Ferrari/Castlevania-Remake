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
	hp -= amount
	Ui.remove_enemy_health(amount)
	if hp <= 0:
		die()
