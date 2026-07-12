extends Node2D

@onready var castle_anim: AnimatedSprite2D = $Menu_Screen/CastleAnim
@onready var color_rect: ColorRect = $Menu_Screen/ColorRect

@onready var animation_player_intro: AnimationPlayer = $Intro/AnimationPlayerIntro

@onready var menu_screen: Node2D = $Menu_Screen
@onready var intro: Node2D = $Intro
const PROLOGUE_CASTLE_GATE = preload("uid://bksro4ofyddxx")


func _ready() -> void:
	Ui.visible = false
	AudioManager.stop_music()
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Enter"):
		print("ENTROU")
		animation_button()
		
func finish_animation():
	castle_anim.play("loop")
		
func animation_button():
	for i in range(5):
		color_rect.visible = true
		
		await get_tree().create_timer(0.17).timeout
		
		color_rect.visible = false
		
		await get_tree().create_timer(0.17).timeout
	
	play_intro()

func play_intro():
	menu_screen.visible = false
	
	await get_tree().create_timer(0.5).timeout
	
	Ui.visible = true
	intro.visible = true
	animation_player_intro.play("intro")
	AudioManager.play_sound_effect(PROLOGUE_CASTLE_GATE, "Master", -5)
	
func next_scene():
	print("NEXT SCENE")
