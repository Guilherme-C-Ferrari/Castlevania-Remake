@warning_ignore_start("unused_signal")
extends Node

signal next_level_reached(next_level: String)
signal level_loaded(new_tilemap: TileMapLayer)
signal player_spawned(player: CharacterBody2D)
signal request_camera_reference
signal respond_camera_reference(camera: Camera2D)
signal player_died
signal game_over
signal boss_won
signal disable_camera_follow
