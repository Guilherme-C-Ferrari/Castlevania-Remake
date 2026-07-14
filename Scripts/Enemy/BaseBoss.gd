extends BaseEnemy
class_name BaseBoss

@export var drop_position : Marker2D
@onready var is_active : bool = false
const boss_fire_explosion = preload("res://Scenes/Effect/boss_fire_explosion.tscn")
const ORB_RES = preload("uid://8xs0auhitwid")

func _ready() -> void:
	super()

func _physics_process(_delta: float) -> void:
	update_direction()

func activate() -> void:
	is_active = true

func drop_item() -> void:
	spawn_drop.call_deferred(ORB_RES)

func spawn_drop(item_resource: Resource) -> void:
	if not item_resource or not ITEM_DROP_SCENE: return
	var drop_instance = ITEM_DROP_SCENE.instantiate()
	if "item_resource" in drop_instance:
		drop_instance.item_resource = item_resource
	get_parent().add_child(drop_instance)
	drop_instance.global_position = drop_position.global_position

func on_receive_damage(amount: int) -> void:
	AudioManager.play_sound_effect(enemy_destroyer, "SFX", -12, 0.85)
	spawn_explosion()
	hp -= amount
	Ui.remove_enemy_health(amount)
	if hp <= 0:
		die()

func spawn_boss_explosion() -> void:
	var boss_explosion = boss_fire_explosion.instantiate()
	boss_explosion.global_position = sprite.global_position
	get_parent().add_child(boss_explosion)

func die() -> void:
	AudioManager.play_sound_effect(enemy_destroyer, "SFX", -12, 0.85)
	sprite.set_deferred("visible", false)
	hit_box.get_child(0).set_deferred("disabled", true)
	Ui.add_score(experience)
	spawn_boss_explosion()
	drop_item()
	queue_free()
