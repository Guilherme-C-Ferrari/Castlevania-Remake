extends BaseEnemy

@export var detection_range : float = 150.0

func _ready() -> void:
	hp = 1
	experience = 200
	damage = 2
	move_speed = 75
	hit_box = $HitBox
	hit_box.body_entered.connect(_on_player_damaged)
