extends CanvasLayer 

var timer_enable := false
var wip_level := 1
@onready var ui: UI = $UI_Controller/UI

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
