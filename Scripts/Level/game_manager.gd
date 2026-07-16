extends Node

@onready var camera: Camera2D = $Camera2D

# Mudamos os exports para String para que você digite o nome da fase no Inspector
@export_enum("menu", "game_over", "end", "Level_1_1", "level_1_2", "level_1_3", "level_1_3_1", "level_1_3_2", "level_1_4") var starting_level_name: String = "Level_1_1"
@export_enum("menu", "game_over", "end", "Level_1_1", "level_1_2", "level_1_3", "level_1_3_1", "level_1_3_2", "level_1_4") var try_again_scene_name: String = "game_over"

var current_level_node: Node2D
var current_level_packed_scene: PackedScene

const MENU = preload("uid://cfptssnl1feyh")
const GAME_OVER = preload("uid://cgmlv67uea4t8")
const END = preload("uid://dgcujtiiw3dfs")

const LEVEL_1_1 = preload("uid://c5gs8koxst3jx")
const LEVEL_1_2 = preload("uid://cw68qtlqoctd4")
const LEVEL_1_3 = preload("uid://jdwcbvm762ce")
const LEVEL_1_3_1 = preload("uid://binnrgn4csteq")
const LEVEL_1_3_2 = preload("uid://d1spkvjd6hjvy")
const LEVEL_1_4 = preload("uid://caaru1k15oibo")

var game_leveis = {
	# Telas de sistema e fluxo
	"menu": MENU,
	"game_over": GAME_OVER,
	"end": END,
	
	# Fases do jogo
	"Level_1_1": LEVEL_1_1,
	"level_1_2": LEVEL_1_2,
	"level_1_3": LEVEL_1_3,
	"level_1_3_1": LEVEL_1_3_1,
	"level_1_3_2": LEVEL_1_3_2,
	"level_1_4": LEVEL_1_4
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.next_level_reached.connect(change_current_level)
	SignalManager.player_spawned.connect(update_player)
	SignalManager.level_loaded.connect(update_tilemap)
	SignalManager.request_camera_reference.connect(send_camera_reference)
	SignalManager.player_died.connect(player_died)
	SignalManager.game_over.connect(game_over)
	
	change_current_level(starting_level_name)

func update_player(new_player: CharacterBody2D):
	camera.update_player_node(new_player)

func update_tilemap(new_tilemap: TileMapLayer):
	camera.update_camera_limits(new_tilemap)

func change_current_level(level_name: String):
	# Verifica se a chave existe no dicionário para evitar crashes
	if not game_leveis.has(level_name):
		print("Erro: A cena '" + level_name + "' não existe no dicionário game_leveis!")
		return
		
	if current_level_node:
		current_level_node.queue_free()
		
	var target_scene = game_leveis[level_name]
	current_level_packed_scene = target_scene
	
	var new_current_level = target_scene.instantiate()
	add_child(new_current_level)
	camera.can_follow_player = true
	current_level_node = new_current_level

func player_died():
	if current_level_node:
		current_level_node.queue_free()
	current_level_node = current_level_packed_scene.instantiate()
	add_child(current_level_node)
	AudioManager.play_current_music()

func game_over():
	if current_level_node:
		current_level_node.queue_free()
	camera.free_limits()
	camera.position = Vector2(128,120)
	
	if game_leveis.has(try_again_scene_name):
		var try_again_scene = game_leveis[try_again_scene_name]
		var new_current_level = try_again_scene.instantiate()
		add_child(new_current_level)
		current_level_node = new_current_level
	else:
		print("Erro: Tela de game_over não configurada corretamente!")

func send_camera_reference():
	SignalManager.respond_camera_reference.emit(camera)
