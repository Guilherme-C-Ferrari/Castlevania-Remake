extends Control
class_name UI

@onready var score_points: Label = $Score/Score_points
@onready var player_health_count: TextureProgressBar = $Player/Player_health_count
@onready var enemy_health_count: TextureProgressBar = $Enemy/Enemy_health_count
@onready var time_seconds: Label = $Time/Time_seconds
@onready var stage_level: Label = $Stage/Stage_level
@onready var heart_count: Label = $Hearts/Heart_count
@onready var player_lifes_count: Label = $Player_lifes/Player_lifes_count
@onready var weapon_sprite: TextureRect = $Power/TextureRect
@onready var multi_item: Control = $Multi_item


func _ready() -> void:
	player_health_count.max_value = 16
	player_health_count.min_value = 0
	enemy_health_count.max_value = 16
	enemy_health_count.min_value = 0
	
func add_score(score: int):
	var new_score := int(score_points.text) + score
	score_points.text = str(new_score).pad_zeros(6)
	
func set_score(new_score: int):
	score_points.text = str(new_score).pad_zeros(6)

func set_time(new_time: int):
	time_seconds.text = str(new_time).pad_zeros(4)
	
func get_time() -> int:
	return int(time_seconds.text)
	
	
func decrease_time(decrease_timer: int) -> int:
	var current_time = int(time_seconds.text)
	if current_time <= 0:
		return current_time
	time_seconds.text = str(current_time - decrease_timer).pad_zeros(4)
	return current_time - decrease_timer

func set_stage(new_stage: int):
	stage_level.text = str(new_stage).pad_zeros(2)
	
func add_extra_point(extra_point: int):
	var new_hearts := int(heart_count.text) + extra_point
	heart_count.text = str(new_hearts).pad_zeros(2)
	
func remove_extra_point(remove_point: int ) -> bool:
	var current_hearts = int(heart_count.text) - remove_point
	if current_hearts < 0:
		return false
	else:
		heart_count.text = str(current_hearts).pad_zeros(2)
		return true

func get_extra_point() -> int:
	return int(heart_count.text)
	
func set_extra_point(point: int):
	heart_count.text = str(point).pad_zeros(2)

func set_player_life(new_player_life: int):
	player_lifes_count.text = str(new_player_life).pad_zeros(2)
	
func remove_player_life(damage_life: int) -> int:
	var current_lifes := int(player_lifes_count.text) - damage_life
	current_lifes = clampi(current_lifes, 0, 99) 
	player_lifes_count.text = str(current_lifes).pad_zeros(2)
	return current_lifes
	
func add_player_health(heal_health: int):
	player_health_count.value = clampf(player_health_count.value + heal_health, 0, 16)
	
func remove_player_health(damage_health: int) -> int:
	print("plauer damage")
	player_health_count.value = clampf(player_health_count.value - damage_health, 0, 16)
	return int(player_health_count.value)
	
func set_player_health(new_player_health: int):
	player_health_count.value = clampi(new_player_health, 0, 16)
	
func add_enemy_health(heal_health: int):
	enemy_health_count.value = clampf(enemy_health_count.value + heal_health, 0, 16)
	
func remove_enemy_health(damage_health: int) -> int:
	enemy_health_count.value = clampf(enemy_health_count.value - damage_health, 0, 16)
	return int(enemy_health_count.value)
	
func set_enemy_health(new_enemy_health: int):
	enemy_health_count.value = clampi(new_enemy_health, 0, 16)
	
func set_weapon_sprite(weapon_texture: Texture):
	weapon_sprite.texture = weapon_texture

func multi_item_enable():
	multi_item.visible = true
	
func multi_item_disable():
	multi_item.visible = false
