extends Node

const LEVEL_1_1 = preload("uid://c5gs8koxst3jx")
const LEVEL_1_2 = preload("uid://cw68qtlqoctd4")
const LEVEL_1_3_1 = preload("uid://binnrgn4csteq")
const LEVEL_1_3_2 = preload("uid://d1spkvjd6hjvy")
const LEVEL_1_4 = preload("uid://caaru1k15oibo")

@onready var level_1_1: Node2D
@onready var level_1_2: Node2D
@onready var level_1_3_1: Node2D
@onready var level_1_3_2: Node2D
@onready var level_1_4: Node2D

@onready var camera: Camera2D = $Camera2D

var current_level: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.next_level_reached.connect(change_current_level)
	SignalManager.player_spawned.connect(update_player)
	SignalManager.level_loaded.connect(update_tilemap)
	# current_level inicial menu da pausa
	# cutscene inicial
	change_current_level(LEVEL_1_1)

func update_player(new_player: CharacterBody2D):
	#current_player = new_player
	camera.update_player_node(new_player)

func update_tilemap(new_tilemap: TileMapLayer):
	#current_tilemap = new_tilemap
	camera.update_camera_limits(new_tilemap)

func change_current_level(new_scene):
	if current_level:
		current_level.queue_free()
	var new_current_level = new_scene.instantiate(PackedScene.GEN_EDIT_STATE_MAIN_INHERITED)
	add_child(new_current_level)
	current_level = new_current_level
