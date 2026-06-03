extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_player: AnimatedSprite2D = $AnimatedSpritePlayer

@export var SPEED = 100.0
@export var JUMP_VELOCITY = -300.0

@export var is_jumping = false
@export var is_walking := false
@export var moving := 0.0
@export var is_ducking:= false
@export var is_attacking := false

func _ready() -> void:
	animation_player.play("idle")

func _physics_process(delta: float) -> void:
	
	get_inputs()
	player_animation_control()
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity()  * delta

	# Handle jump.
	if is_jumping and is_on_floor() and !is_ducking:
		velocity.y = JUMP_VELOCITY
	
	if !is_jumping and is_on_floor() and !is_ducking:
		if moving > 0.0:
			velocity.x = moving * SPEED
		elif moving < 0.0:
			velocity.x = moving * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	elif is_ducking:
		velocity.x = 0

	move_and_slide()


func player_animation_control():
	if is_jumping  and is_on_floor() and !is_ducking:
		#animation_player.play("jump")
		return
		
	if !is_jumping and is_on_floor() and !is_ducking:
		if moving > 0.0:
			animated_sprite_player.flip_h = true
			#animation_player.play("walk")
		elif moving < 0.0:
			animated_sprite_player.flip_h = false
			#animation_player.play("walk")
		else:
			pass
			#animation_player.play("idle")
	elif is_ducking:
		pass
		#animation_player.play("duck")
		
	if is_attacking:
		pass
		#animation_player.play("idle_attack")
			 


func get_inputs():
	is_jumping = Input.is_action_just_pressed("jump")
	moving = Input.get_axis("move_left", "move_right")
	is_ducking = Input.is_action_pressed("descend_stair")
	is_attacking = Input.is_action_just_pressed("attack")
	
	if moving != 0:
		is_walking = true
	else:
		is_walking = false
