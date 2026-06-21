extends Node2D

func _ready() -> void:
	var randomizer = randf()
	var x_star = -3.0 if randomizer > 0.5 else 2.0
	var y_star = -5.0
	var x_ball = 2.0 if randomizer > 0.5 else -3.0
	var y_ball = -1.0
	$FireStar.position = Vector2(x_star, y_star)
	$FireBall.position = Vector2(x_ball, y_ball)
	
	$FireStar.play("default")
	$FireBall.play("default")
	$FireBall.animation_finished.connect(_on_animation_finished)

func _on_animation_finished() -> void:
	queue_free()
