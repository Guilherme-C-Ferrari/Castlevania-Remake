extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_player: AnimatedSprite2D = $AnimatedSpritePlayer

@export var SPEED = 100.0
@export var JUMP_VELOCITY = -300.0

var is_jumping = false
var moving := 0.0

func _ready() -> void:
	animation_player.play("walk")

func _physics_process(delta: float) -> void:
	
	get_inputs()
	player_animation_control()
	
	
	# Add the gravity.
	if not is_on_floor():
		print(get_gravity() )
		velocity += get_gravity()  * delta

	# Handle jump.
	if is_jumping and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if !is_jumping and is_on_floor():
		if moving > 0.0:
			velocity.x = moving * SPEED
		elif moving < 0.0:
			velocity.x = moving * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func player_animation_control():
	if is_jumping  and is_on_floor():
		animation_player.play("jump")
		
	if !is_jumping and is_on_floor():
		if moving > 0.0:
			animated_sprite_player.flip_h = true
			animation_player.play("walk")
		elif moving < 0.0:
			animated_sprite_player.flip_h = false
			animation_player.play("walk")
		else:
			animation_player.play("idle")


func get_inputs():
	is_jumping = Input.is_action_just_pressed("jump")
	moving = Input.get_axis("move_left", "move_right")
