extends Area2D

enum SwitchType { TURN_ON, TURN_OFF, TURN_ON_AND_OFF }
@export var type: SwitchType = SwitchType.TURN_ON
@export var single_use: bool = false
@export var target_spawner: SpawnerWithSwitch

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
			activate_switch()

func activate_switch() -> void:
	if not target_spawner:
		return
	
	match type:
		SwitchType.TURN_ON:
			target_spawner.turn_spawner_on()
			print("Spawner ativado pelo switch!")
		SwitchType.TURN_OFF:
			target_spawner.turn_spawner_off()
			print("Spawner desativado pelo switch!")
		SwitchType.TURN_ON_AND_OFF:
			if target_spawner.is_on:
				target_spawner.turn_spawner_off()
			else:
				target_spawner.turn_spawner_on()
	
	if single_use:
		queue_free()
