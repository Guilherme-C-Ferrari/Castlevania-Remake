extends Node

signal next_level_reached(next_level: PackedScene)
signal level_loaded(new_tilemap: TileMapLayer)
signal player_spawned(player: CharacterBody2D)
signal request_camera_reference
signal respond_camera_reference(camera: Camera2D)
signal player_died
signal game_over
