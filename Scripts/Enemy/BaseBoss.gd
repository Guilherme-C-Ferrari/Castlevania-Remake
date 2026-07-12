extends BaseEnemy
class_name BaseBoss

@onready var is_active : bool = false

func _ready() -> void:
	super()

func _physics_process(_delta: float) -> void:
	update_direction()

func activate() -> void:
	is_active = true
