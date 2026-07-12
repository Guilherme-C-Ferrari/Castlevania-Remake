extends Node
class_name BaseStructure

@export var hp: int
@export var item_drop: PackedScene
@export var item_1: Weapon = preload("uid://chuagtkrnyv38")
@export var wip_upgrade: Weapon = preload("uid://bm1pm16uvf2xc")
@export var can_drop_wip: bool = true


@onready var hit_box: CollisionShape2D = $HitBox
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
const CANDLE_DESTROYER = preload("uid://nre3uxhyr27v")

const fire_explosion = preload("res://Scenes/Effect/fire_explosion.tscn")

func on_receive_damage(amount: int) -> void:
	hp -= amount
	if hp <= 0:
		be_destroyed()

func spawn_explosion() -> void:
	var explosion = fire_explosion.instantiate()
	explosion.global_position = sprite.global_position
	get_parent().add_child(explosion)
	
func drop_item():
	var item_drop_scene = item_drop.instantiate()
	if Ui.wip_level != 3 and can_drop_wip  and randf() < 0.8 and item_1.name == "heart":
		item_drop_scene.item_resource = wip_upgrade
	else:
		item_drop_scene.item_resource = item_1
	item_drop_scene.global_position = sprite.global_position
	get_parent().add_child(item_drop_scene)

func be_destroyed() -> void:
	AudioManager.play_sound_effect(CANDLE_DESTROYER, "SFX", -12, 0.85)
	sprite.set_deferred("visible", false)
	hit_box.set_deferred("disabled", true)
	spawn_explosion()
	
	await get_tree().create_timer(0.6).timeout
	
	drop_item()
	queue_free()
