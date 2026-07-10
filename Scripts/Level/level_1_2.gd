extends Node2D

@export var next_level: PackedScene

@onready var tile_map_layer: TileMapLayer = $"Entrance Hall/TileMapLayer"
@onready var player: CharacterBody2D = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.level_loaded.emit(tile_map_layer)
	SignalManager.player_spawned.emit(player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	SignalManager.next_level_reached.emit(next_level)
