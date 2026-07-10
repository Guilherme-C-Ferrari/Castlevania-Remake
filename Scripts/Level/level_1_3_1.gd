extends Node2D

@onready var tile_map_layer: TileMapLayer = $"Crypt A/TileMapLayer"
@onready var player: CharacterBody2D = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.level_loaded.emit(tile_map_layer)
	SignalManager.player_spawned.emit(player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
