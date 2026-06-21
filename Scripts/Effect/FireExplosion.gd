extends Node2D

func _ready() -> void:
	$FireStar.play("default")
	$FireBall.play("default")
	$FireBall.animation_finished.connect(_on_animation_finished)

func _on_animation_finished() -> void:
	queue_free()
