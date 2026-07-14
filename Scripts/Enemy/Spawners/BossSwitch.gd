extends Area2D

enum SwitchType { TURN_ON }
@export var type: SwitchType = SwitchType.TURN_ON
@export var single_use: bool = false
@export var target_boss: BaseBoss
@export var boss_wall: StaticBody2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
			activate_switch()

func activate_switch() -> void:
	if not target_boss:
		return
	
	match type:
		SwitchType.TURN_ON:
			SignalManager.disable_camera_follow.emit()
			Ui.set_enemy_health(target_boss.hp)
			target_boss.activate()
			AudioManager.change_current_music(AudioManager.POISON_MIND_MUSIC)
			if boss_wall:
				var wall_collision = boss_wall.get_node_or_null("CollisionShape2D")
				wall_collision.set_deferred("disabled", false)
	if single_use:
		queue_free()
