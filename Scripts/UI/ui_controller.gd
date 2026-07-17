extends CanvasLayer 

@onready var ui: UI = $UI_Controller/UI

var timer_enable := false

#PLAYER STATUS
var wip_level := 1

var current_weapon := ""
var current_weapon_heart_cost := 0
var weapon_in_use := 1

var timer: Timer

#WEAPONS
const DAGGER = preload("uid://gtefgqnoffuc")
const DAGGER_SFX = preload("uid://fpbry8offwh6")

const AXE = preload("uid://bcd48f66fp52h")
const AXE_SFX = preload("uid://b1x36h5p0hjvy")

const WATER = preload("uid://dgbbxrbrro17b")

const WATCH_SFX = preload("uid://dwrd6pbmrsc0e")

const TIME_SFX = preload("uid://b0f33n0h8l4ad")

func _ready() -> void:
	setup_timer()
	set_inital_time(300)
	set_player_life(3)

func reset_player_stats():
	stop_timer()
	set_player_health(16)
	set_enemy_health(16)
	set_inital_time(200)
	ui.set_extra_point(5)
	wip_level = 1
	ui.multi_item_disable()
	
	ui.set_weapon_sprite(null)
	current_weapon = ""
	weapon_in_use = 1
	
func restart_ui():
	reset_player_stats()
	set_player_life(3)
	set_inital_time(300)
	ui.set_score(0)
	ui.set_stage(00)

func add_score(score: int):
	ui.add_score(score)
	
func set_player_health(new_player_health: int):
	ui.set_player_health(new_player_health)
	
func remove_player_health(damage_health: int):
	var current_health = ui.remove_player_health(damage_health)
	
	if current_health <= 0:
		stop_timer()
		var player = get_tree().get_first_node_in_group("player")
		player.death()

func add_player_health(heal_health: int):
	for i in range(heal_health):
		ui.add_player_health(1)
		await get_tree().create_timer(0.2).timeout

func set_enemy_health(new_enemy_health: int):
	ui.set_enemy_health(new_enemy_health)
	
func remove_enemy_health(damage_health: int):
	ui.remove_enemy_health(damage_health)

func add_enemy_health(heal_health: int):
	for i in range(heal_health):
		ui.add_enemy_health(1)
		await get_tree().create_timer(0.2).timeout

func setup_timer():
	timer = Timer.new()
	timer.wait_time = 1.0
	timer.autostart = false
	timer.timeout.connect(timer_timeout)
	add_child(timer)

func timer_timeout():
	var current_time = ui.decrease_time(1)
			
	if current_time < 30:
		AudioManager.play_sound_effect(TIME_SFX, "SFX", -5, 1,1)
	if current_time <= 0:
		
		var player = get_tree().get_first_node_in_group("player")
		player.death()
		Ui.stop_timer()
		 
		print("TEMPO ACABOU")
	
func set_inital_time(new_time: int):
	ui.set_time(new_time)
	
func stop_timer():
	timer.stop()
	
func run_timer():
	if timer.is_stopped():
		timer.start()

func get_timer() -> int:
	return ui.get_time()
	
func decrease_time(decrease_timer: int) -> int:
	return ui.decrease_time(decrease_timer)
	
func set_stage(new_stage: int):
	ui.set_stage(new_stage)
	
func add_extra_point(extra_point: int):
	ui.add_extra_point(extra_point)
	
func get_extra_point() -> int:
	return ui.get_extra_point()
	
func remove_extra_point(remove_point: int):
	ui.remove_extra_point(remove_point)
	
func set_player_life(new_player_life: int):
	ui.set_player_life(new_player_life)
	
func remove_player_life(damage_life: int):
	var current_lifes = ui.remove_player_life(damage_life)
	Ui.stop_timer()
	if current_lifes <= 0:
		SignalManager.game_over.emit()
	else:
		reset_player_stats()
		SignalManager.player_died.emit()

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

func set_current_weapon(name_weapon: String, heart_cost: int, weapon_sprite: Texture):
	ui.set_weapon_sprite(weapon_sprite)
	
	current_weapon = name_weapon
	current_weapon_heart_cost = heart_cost
	
func use_weapon(position: Vector2, direction_right: int):
	if current_weapon == "" and weapon_in_use != 0:
		return
	
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
			AudioManager.stop_music()
			AudioManager.play_sound_effect(WATCH_SFX, "SFX", -12)
			var enemies = Engine.get_main_loop().get_nodes_in_group("enemy")
			for enemy in enemies:
					enemy.stop_time()
					
			var spawners = Engine.get_main_loop().get_nodes_in_group("spawner")
			for spawner in spawners:
					spawner.turn_spawner_off()
			await get_tree().create_timer(2.7).timeout
			
			var enemies_after = Engine.get_main_loop().get_nodes_in_group("enemy")
			for enemy in enemies_after:
					enemy.resume_time()
					
			var spawners_after = Engine.get_main_loop().get_nodes_in_group("spawner")
			for spawner in spawners_after:
					spawner.turn_spawner_on()
					
			weapon_in_use += 1
			AudioManager.play_current_music()
			
		elif current_weapon == "water":
			
			var water = WATER.instantiate()
			water.global_position = Vector2(position.x, position.y - 16)
			water.scale.x = direction_right
			get_tree().current_scene.add_child(water)
			weapon_in_use += 1
	return
	
func enable_multi_item():
	ui.multi_item_enable()
	weapon_in_use = 2
	
func disable_multi_item():
	ui.multi_item_disable()

func add_weapon_usage():
	weapon_in_use += 1
	
func can_use_weapon():
	return current_weapon != "" and current_weapon_heart_cost <= ui.get_extra_point() and weapon_in_use != 0
	
func restart_status():
	disable_multi_item()
	wip_level = 1
