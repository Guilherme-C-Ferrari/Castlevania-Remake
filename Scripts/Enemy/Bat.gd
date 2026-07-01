extends BaseEnemy

@export var detection_range : float = 300.0

func _ready() -> void:
	super()
	hp = 1
	experience = 200
	damage = 2
	move_speed = 75
