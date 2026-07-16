extends Node2D

const LEVEL_1_1 = preload("uid://c5gs8koxst3jx")
const MENU = preload("uid://cfptssnl1feyh")

@onready var heart_continue: Sprite2D = $Heart_Continue
@onready var heart_end: Sprite2D = $Heart_End

var continue_button = true
var end_button = false

func _process(_delta: float) -> void:
	if Input.is_action_pressed("descend_stair"):
		end_option()
	elif Input.is_action_pressed("ascend_stair"):
		continue_option()
		
	if Input.is_action_just_pressed("Enter"):
		Ui.restart_ui()
		if continue_button:
			continue_selected()
		elif end_button:
			end_selected()
		
func continue_option():
	heart_continue.visible = true
	heart_end.visible = false
	
	continue_button = true
	end_button = false
	
func end_option():
	heart_continue.visible = false
	heart_end.visible = true
	
	continue_button = false
	end_button = true
	
	
func continue_selected():
	SignalManager.next_level_reached.emit("Level_1_1")
	
func end_selected():
	SignalManager.next_level_reached.emit("menu")
