extends CharacterBody2D

@onready var player_stair_controller: Node = $Player_Stair_Controller
@onready var player_animation_controller: Node = $Player_Animation_Controller
@onready var player_hurt_controller: Node = $Player_Hurt_Controller
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
@onready var player_combat_controller: Node2D = $Player_Combat_Controller
@onready var visual: Node2D = $Visual
@onready var animated_sprite_player: AnimatedSprite2D = $Visual/AnimatedSpritePlayer
@onready var collision := $CollisionShape2D

var jump_pressed := false
var move_pressed := 0.0
var duck_pressed := false
var ascend_pressed := false
var descend_pressed := false
var attack_pressed := false
var upgrade_wip := false

var moving := 0.0


var hurt_timer := 0.0
var knockback_velocity := Vector2.ZERO
var invincible := false

#Public Player Vars
#----------------------------------------------------------
@export_category("PLAYER")
@export_group("Stats")
@export var SPEED = 100.0
@export var JUMP_VELOCITY = -300.0

#----------------------------------------------------------
@export_group("Animation Triggers")
@export_subgroup("Movements")
@export var player_can_control := true
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
@export var is_moving_on_stair := false
#----------------------------------------------------------


func _physics_process(delta: float) -> void:
	if Engine.get_physics_frames() < 15: 
		return
		
	player_animation_controller.player_animation_control()
	debug_tool()
	
	if player_stair_controller.handle_stairs(delta):
		return

	movement(delta)
	

func movement(delta):
	if is_hurt:
		hurt_timer -= delta
		
		velocity.x = knockback_velocity.x
		velocity.y += get_gravity().y * player_hurt_controller.HURT_GRAVITY * delta
		
		move_and_slide()
		
		if hurt_timer <= 0 and is_on_floor():
			is_hurt = false
			player_can_control = true
			knockback_velocity = Vector2.ZERO
			
			if !is_dead:
				player_hurt_controller.start_invincibility()
			else:
				player_can_control = false
		
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity()  * delta

	# Handle jump.
	if is_jumping and is_on_floor() and !is_ducking and !is_attacking:
		velocity.y = JUMP_VELOCITY
	
	if !is_jumping and is_on_floor() and !is_ducking and !is_attacking:
		if moving > 0.0:
			velocity.x = moving * SPEED
		elif moving < 0.0:
			velocity.x = moving * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	elif is_ducking:
		velocity.x = 0
	elif is_attacking and !is_jumping:
		velocity.x = 0

	move_and_slide()
	if attack_pressed and playback.get_current_node() != "Attack_State":
		is_attacking = true
	
func take_hit(enemy_facing: Vector2):
	player_hurt_controller.take_hit(enemy_facing)

func finish_attack_anim():
	is_attacking = false
	
func death():
	is_dead = true
	pass
	
func turn_player(facing_side: String):
	if facing_side == "RIGHT":
		visual.scale = Vector2(-1, visual.scale.y)
		player_combat_controller.scale = Vector2(-1, visual.scale.y)
	elif facing_side == "LEFT":
		visual.scale = Vector2(1, visual.scale.y)
		player_combat_controller.scale = Vector2(1, visual.scale.y)


func debug_tool():
	if upgrade_wip:
		Ui.upgrade_wip_level()
