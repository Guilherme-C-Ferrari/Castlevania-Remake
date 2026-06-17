extends BaseEnemy

func _ready() -> void:
	hp = 1
	experience = 100
	damage = 2
	move_speed = 75
	hit_box = $HitBox
	hit_box.body_entered.connect(_on_player_damaged)
