extends CharacterBody2D

@export var item_resource : Weapon
@onready var item_sprite: Sprite2D = $Item_Sprite

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var tempo: float = 0.0
var velocidade_onda: float = 8.0 
var amplitude_onda: float = 90.0 

func _ready() -> void:
	item_sprite.texture = item_resource.sprite

func _physics_process(delta):
	if not is_on_floor():
		if item_resource and item_resource.name.to_lower() == "heart":
			velocity.y += (gravity - 800) * delta
			tempo += delta * velocidade_onda
			velocity.x = cos(tempo) * amplitude_onda
		else:
			velocity.y += gravity * delta
	else:
		velocity.y = 0
		velocity.x = 0 

	move_and_slide()

func collect_area(_body: Node2D):
	ItemController.item_collected(item_resource.name, item_resource.heart_cost, item_resource.item_points, item_resource.item_type, item_resource.sprite)
	self.queue_free()
