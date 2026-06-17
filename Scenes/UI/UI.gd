extends Control

@onready var score_points: Label = $Score/Score_points
@onready var player_health_count: TextureProgressBar = $Player/Player_health_count
@onready var enemy_health_count: TextureProgressBar = $Enemy/Enemy_health_count
@onready var time_seconds: Label = $Time/Time_seconds
@onready var stage_level: Label = $Stage/Stage_level
@onready var heart_count: Label = $Hearts/Heart_count
@onready var player_lifes_count: Label = $Player_lifes/Player_lifes_count

func _ready() -> void:
	player_health_count.max_value = 16
	player_health_count.min_value = 0
	enemy_health_count.max_value = 16
	enemy_health_count.min_value = 0
	
func add_score(score: int):
	var new_score := int(score_points.text) + score
	score_points.text = str(new_score).pad_zeros(6)

func set_timer(new_time: int):
	time_seconds.text = str(new_time).pad_zeros(4)

func set_stage(new_stage: int):
	stage_level.text = str(new_stage).pad_zeros(2)
	
func add_extra_point(extra_point: int):
	var new_hearts := int(heart_count.text) + extra_point
	heart_count.text = str(new_hearts).pad_zeros(2)
	
func set_player_life(new_player_life: int):
	player_lifes_count.text = str(new_player_life).pad_zeros(2)
	
func remove_player_life(damage_life: int):
	var current_lifes := int(player_lifes_count.text) - damage_life
	current_lifes = clampi(current_lifes, 0, 99) 
	player_lifes_count.text = str(current_lifes).pad_zeros(2)
	
func add_player_health(heal_health: int):
	player_health_count.value = clampi(player_health_count.value + heal_health, 0, 16)
	
func remove_player_health(damage_health: int):
	player_health_count.value = clampi(player_health_count.value - damage_health, 0, 16)

func set_player_health(new_player_health: int):
	player_health_count.value = clampi(new_player_health, 0, 16)
