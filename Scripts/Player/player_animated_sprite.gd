extends AnimatedSprite2D


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
