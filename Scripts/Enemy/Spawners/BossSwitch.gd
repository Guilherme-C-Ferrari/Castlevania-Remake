extends Area2D

enum SwitchType { TURN_ON, TURN_OFF, TURN_ON_AND_OFF }
@export var type: SwitchType = SwitchType.TURN_ON
@export var single_use: bool = false
@export var target_boss: BaseBoss

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
			target_boss.activate()
			AudioManager.change_current_music(AudioManager.POISON_MIND_MUSIC)
		_:
			pass
	
	if single_use:
		queue_free()
