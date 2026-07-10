extends BaseEnemy

@export var detection_range : float = 500.0
@export var is_spawner_jumper: bool = true
@onready var can_shoot: bool = true

func _ready() -> void:
	super()
	hp = 1
	experience = 300
	damage = 2
	move_speed = 35
