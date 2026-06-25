extends CharacterBody2D

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
@export_group("Hurt")
@export var HURT_TIME := 0.2
@export var KNOCKBACK_FORCE := 220.0
@export var INVINCIBILITY_TIME := 1.0
@export var HURT_GRAVITY := 0.2
@export var HURT_HEIGHT := -120

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
#----------------------------------------------------------


func _physics_process(delta: float) -> void:
	if Engine.get_physics_frames() < 15: 
		return
		
	get_inputs()
	player_animation_control()
	debug_tool()
	
	if is_hurt:
		hurt_timer -= delta
		
		velocity.x = knockback_velocity.x
		velocity.y += get_gravity().y * HURT_GRAVITY * delta
		
		move_and_slide()
		
		if hurt_timer <= 0 and is_on_floor():
			is_hurt = false
			player_can_control = true
			knockback_velocity = Vector2.ZERO
			
			if !is_dead:
				start_invincibility()
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

func player_animation_control():	
	move_animation()
	jump_animation()
	duck_animation()
	attack_animation()

func move_animation():
	if player_can_control:
		if move_pressed != 0 and is_on_floor() and !is_attacking:
			is_walking = true
			if move_pressed == 1:
				visual.scale = Vector2(-1, visual.scale.y)
				player_combat_controller.scale = Vector2(-1, visual.scale.y)
			else:
				visual.scale = Vector2(1, visual.scale.y)
				player_combat_controller.scale = Vector2(1, visual.scale.y)
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

func attack_animation():
	if attack_pressed and playback.get_current_node() != "Attack_State":
		is_attacking = true

func take_hit(enemy_facing: Vector2):
	if invincible:
		return
	
	is_hurt = true
	player_can_control = false
	hurt_timer = HURT_TIME
	
	var dir = enemy_facing.normalized()
	knockback_velocity = Vector2(
		dir.x * KNOCKBACK_FORCE,
		HURT_HEIGHT
	)
	
	if enemy_facing.x == 1:
		visual.scale = Vector2(1, visual.scale.y)
		player_combat_controller.scale = Vector2(-1, visual.scale.y)
	else:
		visual.scale = Vector2(-1, visual.scale.y)
		player_combat_controller.scale = Vector2(1, visual.scale.y)
	
	is_attacking = false
	is_jumping = false
	is_ducking = false
	is_walking = false
	moving = 0
	velocity = knockback_velocity
	
	set_collision_layer_value(2, false)

func start_invincibility() -> void:
	invincible = true
	
	set_collision_layer_value(2, false)
	
	var tween = get_tree().create_tween()
	tween.tween_property(visual, "modulate:a", 0.3, 0.15)
	
	await get_tree().create_timer(INVINCIBILITY_TIME).timeout
	
	end_invincibility()
	
func end_invincibility() -> void:
	invincible = false

	set_collision_layer_value(2, true)
	
	var tween = get_tree().create_tween()
	tween.tween_property(visual, "modulate:a", 1.0, 0.15)

func get_inputs():
	if player_can_control:
		jump_pressed = Input.is_action_just_pressed("jump")
		move_pressed = Input.get_axis("move_left", "move_right")
		duck_pressed = Input.is_action_pressed("descend_stair")
		descend_pressed = Input.is_action_pressed("descend_stair")
		ascend_pressed = Input.is_action_pressed("ascend_stair")
		attack_pressed = Input.is_action_just_pressed("attack")
		upgrade_wip = Input.is_action_just_pressed("upgrade")

func finish_attack_anim():
	is_attacking = false
	
func death():
	is_dead = true
	pass
func debug_tool():
	if upgrade_wip:
		Ui.upgrade_wip_level()
