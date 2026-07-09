extends CharacterBody2D

@export var item_resource : Weapon
@onready var item_sprite: Sprite2D = $Item_Sprite

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	item_sprite.texture = item_resource.sprite

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0
		velocity.x = 0 

	move_and_slide()

func collect_area(_body: Node2D):
	ItemController.item_collected(item_resource.name, item_resource.heart_cost, item_resource.item_type, item_resource.sprite)
	self.queue_free()
