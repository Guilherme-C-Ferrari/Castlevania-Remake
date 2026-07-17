extends CharacterBody2D

@export var velocity_x := 100.0
@export var jump_force := -100.0
@export var water_gravity := 400.0

const HOLY_WATER_SFX = preload("uid://dtnp01u3f3k53")

@onready var water_sprite: Sprite2D = $Water_SPRITE
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var is_burning = false

func _ready() -> void:
	velocity.x = velocity_x * -scale.x
	velocity.y = jump_force

func _physics_process(delta: float) -> void:
	if is_burning:
		velocity = Vector2.ZERO
	else:
		velocity.y += water_gravity * delta
	move_and_slide()
	
	if is_on_floor() and !is_burning:
		AudioManager.play_sound_effect(HOLY_WATER_SFX, "SFX", -12)
		burn()
		
	elif is_on_wall() or is_on_ceiling():
		AudioManager.play_sound_effect(HOLY_WATER_SFX, "SFX", -12)
		destroy_weapon()

func destroy_weapon():
	queue_free()
	Ui.add_weapon_usage()

func _on_body_entered(body: Node2D) -> void:
	if (body.is_in_group("enemy") or body.is_in_group("structure")) and body.has_method("on_receive_damage"):
		body.on_receive_damage(1)
	elif body.is_in_group("Item"):
		pass
		
func burn():
	is_burning = true
	water_sprite.visible = false
	animated_sprite_2d.visible = true
	animated_sprite_2d.play("default")
	
	await get_tree().create_timer(1.40).timeout
	
	destroy_weapon()
