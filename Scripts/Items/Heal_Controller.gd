extends Resource
class_name Heal_Controller


const ALL_CLEAR = preload("uid://da4je48a8h2uc")
const TIME_ADDED_TO_SCORE = preload("uid://fup6adjh61cw")
const HEARTS_ADDED_TO_SCORE = preload("uid://d1clmh8y1daxk")

func heal_collected(name: String, heal_points:int):
	Ui.add_player_health(heal_points)
	
	if name == "orbe":
		end_level()
		
func end_level():
	var tree = Engine.get_main_loop()
	
	Ui.stop_timer()
	AudioManager.stop_music()
	AudioManager.play_sound_effect(ALL_CLEAR, "SFX", -12)
	
	await tree.create_timer(5.5).timeout
	
	var time_count: int = Ui.get_timer()

	for time in range(time_count):
		Ui.decrease_time(1)
		Ui.add_score(10)
		if time % 5 == 0:
			AudioManager.play_sound_effect(TIME_ADDED_TO_SCORE, "SFX", -12, 1, 1)
		await tree.create_timer(0.05).timeout

	await tree.create_timer(1.5).timeout
	
	var heart_count: int = Ui.get_extra_point()

	for heart in range(heart_count):
		Ui.remove_extra_point(1)
		Ui.add_score(100)
		if heart % 2 == 0:
			AudioManager.play_sound_effect(HEARTS_ADDED_TO_SCORE, "SFX", -10, 1, 1)
		await tree.create_timer(0.1).timeout
	
	await tree.create_timer(1.5).timeout
	print("ACABOU, PODE IR PARA PROXIMA FASE")
