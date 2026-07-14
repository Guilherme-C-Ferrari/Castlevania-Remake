extends Node2D

var play_count: int = 0
const MAX_PLAYS: int = 2

func _ready() -> void:
	for child in get_children():
		if "flip_h" in child:
			child.flip_h = true
	play_all()
	if get_child_count() > 0:
		var first_child = get_child(0)
		if first_child.has_signal("animation_finished"):
			first_child.animation_finished.connect(_on_animation_finished)

func play_all() -> void:
	for child in get_children():
		if child.has_method("play"):
			child.play("default")

func _on_animation_finished() -> void:
	play_count += 1
	if play_count < MAX_PLAYS:
		play_all()
	else:
		queue_free()
