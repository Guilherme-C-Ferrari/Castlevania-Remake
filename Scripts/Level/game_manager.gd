extends Node

@onready var level_1_3_spawnpoint: Marker2D = $"Level1_3 spawnpoint"
@onready var level_1_4_spawnpoint: Marker2D = $"Level1_4 spawnpoint"

@onready var camera: Camera2D = $Camera2D

@export var starting_level: PackedScene
@export var try_again_scene: PackedScene

var current_level_node: Node2D
var current_level_packed_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.next_level_reached.connect(change_current_level)
	SignalManager.player_spawned.connect(update_player)
	SignalManager.level_loaded.connect(update_tilemap)
	SignalManager.request_camera_reference.connect(send_camera_reference)
	SignalManager.player_died.connect(player_died)
	SignalManager.game_over.connect(game_over)
	change_current_level(starting_level)

func update_player(new_player: CharacterBody2D):
	camera.update_player_node(new_player)

func update_tilemap(new_tilemap: TileMapLayer):
	camera.update_camera_limits(new_tilemap)

func change_current_level(new_scene: PackedScene):
	if current_level_node:
		current_level_node.queue_free()
	current_level_packed_scene = new_scene
	var new_current_level = new_scene.instantiate(PackedScene.GEN_EDIT_STATE_MAIN_INHERITED)
	add_child(new_current_level)
	camera.can_follow_player = true
	current_level_node = new_current_level
	Ui.run_timer()

func player_died():
	if current_level_node:
		current_level_node.queue_free()
	current_level_node = current_level_packed_scene.instantiate(PackedScene.GEN_EDIT_STATE_MAIN_INHERITED)
	add_child(current_level_node)

func game_over():
	if current_level_node:
		current_level_node.queue_free()
	var new_current_level = try_again_scene.instantiate(PackedScene.GEN_EDIT_STATE_MAIN_INHERITED)
	add_child(new_current_level)

func send_camera_reference():
	SignalManager.respond_camera_reference.emit(camera)
