extends Node2D

@onready var up_area: Area2D = $Up_Area
@onready var down_area: Area2D = $Down_Area

var player = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _on_up_area_body_entered(body: Node2D) -> void:
	if body != player:
		return
	player.get_node("Player_Stair_Controller").enter_stair(up_area.global_position)

func _on_up_area_body_exited(body: Node2D) -> void:
	if body != player:
		return
	player.get_node("Player_Stair_Controller").exit_stair()

func _on_down_area_body_entered(body: Node2D) -> void:
	if body != player:
		return
	player.get_node("Player_Stair_Controller").enter_stair(down_area.global_position)

func _on_down_area_body_exited(body: Node2D) -> void:
	if body != player:
		return
	player.get_node("Player_Stair_Controller").exit_stair()
