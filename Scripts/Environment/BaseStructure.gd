extends Node
class_name BaseStructure

@export var hp: int

@onready var hit_box: Area2D = $HitBox
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

const fire_explosion = preload("res://Scenes/Effect/fire_explosion.tscn")

func on_receive_damage(amount: int) -> void:
	hp -= amount
	if hp <= 0:
		be_destroyed()

func spawn_explosion() -> void:
	var explosion = fire_explosion.instantiate()
	explosion.global_position = sprite.global_position
	get_parent().add_child(explosion)

func be_destroyed() -> void:
	sprite.set_deferred("visible", false)
	hit_box.get_child(0).set_deferred("disabled", true)
	spawn_explosion()
	
	queue_free()
