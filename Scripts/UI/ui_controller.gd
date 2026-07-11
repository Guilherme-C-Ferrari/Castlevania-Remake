extends CanvasLayer 

@onready var ui: UI = $UI_Controller/UI

var timer_enable := false

#PLAYER STATUS
var wip_level := 1

var current_weapon := ""
var current_weapon_heart_cost := 0
var weapon_in_use := 1

#WEAPONS
const DAGGER = preload("uid://gtefgqnoffuc")
const DAGGER_SFX = preload("uid://fpbry8offwh6")

const AXE = preload("uid://bcd48f66fp52h")
const AXE_SFX = preload("uid://b1x36h5p0hjvy")

const WATCH_SFX = preload("uid://dwrd6pbmrsc0e")


func _ready() -> void:
	set_inital_time(300)
	set_player_life(3)
	run_timer()

func add_score(score: int):
	ui.add_score(score)
	
func set_player_health(new_player_health: int):
	ui.set_player_health(new_player_health)
	
func remove_player_health(damage_health: int):
	var current_health = ui.remove_player_health(damage_health)
	
	if current_health <= 0:
		var player = get_tree().get_first_node_in_group("player")
		player.death()

func add_player_health(heal_health: int):
	for i in range(heal_health):
		ui.add_player_health(1)
		await get_tree().create_timer(0.2).timeout

func set_inital_time(new_time: int):
	ui.set_time(new_time)
	
func stop_timer():
	timer_enable = false
	
func run_timer():
	if !timer_enable:
		timer_enable = true
		
		while timer_enable:
			await get_tree().create_timer(1.0).timeout
			var current_time = ui.decrease_time(1)
			
			if current_time <= 0:
				#O tempo acabou
				print("TEMPO ACABOU")

func set_stage(new_stage: int):
	ui.set_stage(new_stage)
	
func add_extra_point(extra_point: int):
	ui.add_extra_point(extra_point)
	
func set_player_life(new_player_life: int):
	ui.set_player_life(new_player_life)
	
func remove_player_life(damage_life: int):
	var current_lifes = ui.remove_player_life(damage_life)
	
	if current_lifes <= 0:
		print("GAME OVER")
	else:
		print("Level respawn")

func get_player_wip_level() -> int:
	return wip_level
	
func upgrade_wip_level():
	
	if wip_level == 3:
		return
	
	wip_level += 1
	
func downgrade_wip_level():
	if wip_level == 1:
		return
	
	wip_level -= 1

func set_current_weapon(name: String, heart_cost: int, weeapon_sprite: Texture):
	ui.set_weapon_sprite(weeapon_sprite)
	
	current_weapon = name
	current_weapon_heart_cost = heart_cost
	
func use_weapon(position: Vector2, direction_right: int):
	if current_weapon == "" and weapon_in_use != 0:
		return
	
	var player = get_tree().get_first_node_in_group("player")
	
	if ui.remove_extra_point(current_weapon_heart_cost):
		weapon_in_use -= 1
		if current_weapon == "axe":
			
			AudioManager.play_sound_effect(AXE_SFX, "SFX", -12)
			
			var axe = AXE.instantiate()
			axe.global_position = Vector2(position.x, position.y - 16)
			axe.scale.x = direction_right
			get_tree().current_scene.add_child(axe)
			
		elif current_weapon == "dagger":
			AudioManager.play_sound_effect(DAGGER_SFX, "SFX", -12)
			
			var dagger = DAGGER.instantiate()
			dagger.global_position = Vector2(position.x, position.y - 16)
			dagger.scale.x = direction_right
			get_tree().current_scene.add_child(dagger)
			
		elif current_weapon == "watch":
			print("USE watch")
			AudioManager.stop_music()
			AudioManager.play_sound_effect(WATCH_SFX, "SFX", -12)
			var enemies = Engine.get_main_loop().get_nodes_in_group("enemy")
			for enemy in enemies:
					enemy.stop_time()
					
			await get_tree().create_timer(2.7).timeout
			
			var enemies_after = Engine.get_main_loop().get_nodes_in_group("enemy")
			for enemy in enemies_after:
					enemy.resume_time()
					
			weapon_in_use += 1
			AudioManager.play_current_music()
			
		elif current_weapon == "water":
			print("USE water")
		
	return


func add_weapon_usage():
	weapon_in_use += 1
	
func can_use_weapon():
	return current_weapon != "" and current_weapon_heart_cost <= ui.get_extra_point() and weapon_in_use != 0
	
