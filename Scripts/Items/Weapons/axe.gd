extends Area2D

@export var velocity_x := 300.0
@export var jump_force := -400.0
@export var axe_gravity := 900.0

var motion := Vector2.ZERO

func _ready() -> void:
	motion.x = velocity_x * -scale.x
	motion.y = jump_force

func _process(delta: float) -> void:
	motion.y += axe_gravity * delta
	position += motion * delta
	rotation += 10 * delta * -scale.x
	
func destroy_weapon():
	queue_free()
	Ui.add_weapon_usage()

func _on_body_entered(body: Node2D) -> void:
	if (body.is_in_group("enemy") or body.is_in_group("structure")) and body.has_method("on_receive_damage"):
		destroy_weapon()
		body.on_receive_damage(1)
	elif  body.is_in_group("Item"):
		destroy_weapon()
		pass
		
	
