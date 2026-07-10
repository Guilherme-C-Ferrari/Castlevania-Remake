extends BaseEnemy

@export var detection_range : float = 500.0
@export var is_spawner_jumper: bool = true
@onready var can_shoot: bool = true
@onready var fireball_projectile: PackedScene = preload("res://Scenes/Enemy/Projectiles/fireball.tscn")

func _ready() -> void:
	super()
	hp = 1
	experience = 300
	damage = 2
	move_speed = 35

func spawn_projectile() -> void:
	var fireball = fireball_projectile.instantiate()
	fireball.global_position = Vector2(global_position.x, global_position.y - 25)
	fireball.walk_direction = walk_direction
	get_parent().add_child(fireball)
