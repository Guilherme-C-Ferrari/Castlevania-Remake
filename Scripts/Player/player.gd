extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_player: AnimatedSprite2D = $AnimatedSpritePlayer

var jump_pressed := false
var move_pressed := 0
var duck_pressed := false
var ascend_pressed := false
var descend_pressed := false
var attack_pressed := false


var moving := 0.0

#Public Player Vars
#----------------------------------------------------------
@export_category("PLAYER")
@export_group("Stats")
@export var SPEED = 100.0
@export var JUMP_VELOCITY = -300.0
#----------------------------------------------------------
@export_group("Animation Triggers")
@export_subgroup("Movements")
@export var is_jumping = false
@export var is_walking := false
@export var is_ducking:= false
#----------------------------------------------------------
@export_subgroup("Attacks")
@export var is_attacking := false
#----------------------------------------------------------
@export_subgroup("States")
@export var is_dead := false
@export var is_falling := false
@export var is_hurt := false
@export var is_ascending := false
@export var is_descending := false
#----------------------------------------------------------
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
	move_animation()
	jump_animation()
	duck_animation()

func get_inputs():

	jump_pressed = Input.is_action_just_pressed("jump")
	move_pressed = Input.get_axis("move_left", "move_right")
	duck_pressed = Input.is_action_pressed("descend_stair")
	descend_pressed = Input.is_action_pressed("descend_stair")
	ascend_pressed = Input.is_action_pressed("ascend_stair")
	
	attack_pressed = Input.is_action_just_pressed("attack")

func move_animation():
	if move_pressed != 0 and is_on_floor():
		is_walking = true
		if move_pressed == 1:
			animated_sprite_player.flip_h = true
		else:
			animated_sprite_player.flip_h = false
	else:
		is_walking = false
	
	if move_pressed != 0:
		moving = move_pressed
	else:
		moving = 0
		
func jump_animation():
	
	if is_on_floor():
		is_jumping = false
	
	if jump_pressed and is_on_floor():
		is_jumping = true
		is_walking = false
	
func duck_animation():
	if !duck_pressed:
		is_ducking = false
		
	if duck_pressed and is_on_floor():
		is_ducking = true
		is_walking = false


	
	
	
	
	
	
	
	
	
	
