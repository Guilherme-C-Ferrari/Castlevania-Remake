extends Node2D

@export var next_scene := preload("uid://jd5cy5hp8kel")

@onready var player: CharacterBody2D = $Player
@onready var change_scene_animation_player: AnimationPlayer = $ChangeSceneAnimationPlayer
@onready var area_2d: Area2D = $"Castle Entrance/Area2D"

# Essa funcao sera usada para impedir o jogador de poder se mover e alterar o timescale do animationplayer para que a animacao seja baseada na
# velocidade e posicao do personagem no inicio e nao por duracao da animacao
func move_to_center_of_castle_entrance():
	print(player.visual.scale)
	if player.position.x > area_2d.position.x and player.visual.scale.x != 1:
		player.animated_sprite_player.flip_h = true

func move_to_right_of_castle_entrance():
	print(player.visual.scale)
	if player.animated_sprite_player.flip_h:
		player.animated_sprite_player.flip_h = false
	if player.visual.scale.x == 1:
		player.animated_sprite_player.flip_h = true

func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player.is_walking = true
		player.animated_sprite_player.play_walk()
		player.player_can_control = false
		var anim: Animation = change_scene_animation_player.get_animation("entering_castle")
		var track_id: int = anim.find_track("Player:position", Animation.TYPE_VALUE)
		var key_id: int = anim.track_find_key(track_id, 0.0)
		anim.track_set_key_value(track_id, key_id, player.position)
		change_scene_animation_player.play("entering_castle")
		change_scene_animation_player.play("entering_castle")
		await change_scene_animation_player.animation_finished
		get_tree().change_scene_to_packed(next_scene)
