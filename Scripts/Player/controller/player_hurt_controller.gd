extends Node

@onready var player: CharacterBody2D = get_parent()

#----------------------------------------------------------
@export_category("HURT")
@export var HURT_TIME := 0.4
@export var KNOCKBACK_FORCE := 65.0
@export var INVINCIBILITY_TIME := 1.0
@export var HURT_GRAVITY := 0.4
@export var HURT_HEIGHT := -120

func take_hit(enemy_facing: Vector2):
	if player.invincible:
		return
	
	player.is_hurt = true
	player.player_can_control = false
	player.hurt_timer = HURT_TIME
	
	var dir = enemy_facing.normalized()
	player.knockback_velocity = Vector2(
		dir.x * KNOCKBACK_FORCE,
		HURT_HEIGHT
	)
	
	if enemy_facing.x == 1:
		player.turn_player("LEFT")
	else:
		player.turn_player("RIGHT")
	
	player.is_attacking = false
	player.is_jumping = false
	player.is_ducking = false
	player.is_walking = false
	player.moving = 0
	player.velocity = player.knockback_velocity
	
	player.set_collision_layer_value(2, false)


func start_invincibility() -> void:
	player.invincible = true
	
	player.set_collision_layer_value(2, false)
	
	var tween = player.get_tree().create_tween()
	tween.tween_property(player.visual, "modulate:a", 0.3, 0.15)
	
	await player.get_tree().create_timer(INVINCIBILITY_TIME).timeout
	
	end_invincibility()


func end_invincibility() -> void:
	player.invincible = false
	
	player.set_collision_layer_value(2, true)
	
	var tween = player.get_tree().create_tween()
	tween.tween_property(player.visual, "modulate:a", 1.0, 0.15)
