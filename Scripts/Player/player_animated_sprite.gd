extends AnimatedSprite2D
@onready var wip_collision: CollisionShape2D = $"../../Player_Combat_Controller/Wip_Attack_Area/CollisionShape2D"
@onready var animated_wip: AnimatedSprite2D = $"../wip/Animated_Wip"


func play_walk():
	if animation != "walk":
		play("walk")
	
func play_jump():
	if animation != "jump":
		play("jump")
	
func play_intro():
	if animation != "intro":
		play("intro")
	
func play_idle():
	if animation != "idle":
		play("idle")
	
func play_hurt():
	if animation != "hurt":
		play("hurt")
	
func play_descending_stairs():
	if animation != "descending_stairs":
		play("descending_stairs")

func play_ascending_stairs():
	if animation != "ascending_stairs":
		play("ascending_stairs")
	
func play_death():
	if animation != "death":
		play("death")
		
func play_duck():
	if animation != "duck":
		play("duck")
	
func play_attack_duck():
	if animation != "attack_duck":
		play("attack_duck")
	
func play_attack_descending_stairs():
	if animation != "attack_descending_stairs":
		play("attack_descending_stairs")
	
func play_attack_ascending_stair():
	if animation != "attack_ascending_stai":
		play("attack_ascending_stai")
	
func play_attack():
	if animation != "attack":
		play("attack")
		
	var wip_level = Ui.get_player_wip_level()
	
	if wip_level == 3:
		animated_wip.animation = "lvl3"
		wip_collision.position = Vector2(-33, wip_collision.position.y)
		wip_collision.shape.set_size(Vector2(40,8))
		return
	
	elif wip_level == 2:
		animated_wip.animation = "lvl2"
		wip_collision.position = Vector2(-25, wip_collision.position.y)
		wip_collision.shape.set_size(Vector2(22,8))
		return
		
	elif wip_level == 1:
		animated_wip.animation = "lvl1"
		wip_collision.position = Vector2(-25, wip_collision.position.y)
		wip_collision.shape.set_size(Vector2(22,8))
		return
		
