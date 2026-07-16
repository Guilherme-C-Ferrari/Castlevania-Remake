@tool
extends Area2D
class_name BreakableWall

@export_group("Configurações de Tamanho")
@export var wall_size: Vector2 = Vector2(16, 16):
	set(value):
		wall_size = value
		_update_sizes()

@export_group("Drop")
@export var item_secret: Resource

@onready var rock_explosion_scene: PackedScene = preload("uid://blgst7a1pb6m2")
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var solid_collision: CollisionShape2D = $SolidCollision/CollisionShape2D
@onready var black_patch: ColorRect = $BlackPatch
@onready var is_broken: bool = false

const ITEM_DROP_SCENE = preload("uid://7jkunyjdw7r2")
const BREAK_WALL_SFX: AudioStream = preload("uid://cshkqx5g6r7t1")

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	_update_sizes()

func _update_sizes() -> void:
	var rect_shape = RectangleShape2D.new()
	rect_shape.size = wall_size
	
	if has_node("CollisionShape2D"):
		collision_shape.set_deferred("shape", rect_shape)
		
	if has_node("SolidCollision/CollisionShape2D"):
		solid_collision.set_deferred("shape", rect_shape)

	if has_node("BlackPatch"):
		black_patch.size = wall_size
		black_patch.position =- wall_size / 2.0
		black_patch.visible = false

func _on_area_entered(_area: Area2D) -> void:
	if is_broken: return
	break_wall()

func break_wall() -> void:
	is_broken = true

	black_patch.color = Color.BLACK
	black_patch.visible = true
	
	solid_collision.set_deferred("disabled", true)
	collision_shape.set_deferred("disabled", true)
	rock_explosion()
	
	if not item_secret or not ITEM_DROP_SCENE: return
	var drop_instance = ITEM_DROP_SCENE.instantiate()
	
	if "item_resource" in drop_instance:
		drop_instance.item_resource = item_secret
	get_parent().add_child.call_deferred(drop_instance)
	drop_instance.global_position = global_position

func rock_explosion() -> void:
	if rock_explosion_scene:
		AudioManager.play_sound_effect(BREAK_WALL_SFX, "SFX", -12, 0.85)
		var explosion = rock_explosion_scene.instantiate()
		get_parent().add_child(explosion)
		explosion.global_position = global_position
		explosion.set_deferred("emitting", true)
