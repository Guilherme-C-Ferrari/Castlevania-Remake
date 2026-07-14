extends Node2D
class_name BaseLevel

const SFX_DOOR = preload("uid://d00jyg5njqw4o")

@export var next_level: PackedScene

@onready var player: CharacterBody2D = $Player
@onready var fake_player: AnimatedSprite2D = $FakePlayer
@onready var tile_map_layer: TileMapLayer

@onready var enemies: Node2D = $Enemies
@onready var environment_items: Node2D = $Environment_Items

var camera_reference: Camera2D
var stage_value: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("miranha")
	SignalManager.respond_camera_reference.connect(update_camera_reference)
	SignalManager.level_loaded.emit(tile_map_layer)
	SignalManager.player_spawned.emit(player)
	SignalManager.request_camera_reference.emit()
	Ui.set_stage(stage_value)
	Ui.run_timer()

func update_camera_reference(new_camera_reference: Camera2D):
	camera_reference = new_camera_reference

func despawn_level():
	if enemies:
		enemies.queue_free()
	if environment_items:
		environment_items.queue_free()
