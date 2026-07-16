extends Area2D

@export_group("Treasure")
@export var treasure_secret: Resource
@export var needs_player_crouched: bool

@onready var fake_treasure_spawn: Marker2D = $"Fake Treasure Spawn"
@onready var fake_treasure_target: Marker2D = $"Fake Treasure Target"
@onready var fake_treasure: Sprite2D = $"Fake Treasure"
const SFX_SECRT_ITEM = preload("uid://c076neud58ut1")

const ITEM_DROP_SCENE = preload("uid://7jkunyjdw7r2")

var triggered: bool = false
var entered: bool = false
var player_reference

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fake_treasure.texture = treasure_secret.sprite

func _process(_delta: float) -> void:
	if entered and not triggered and player_reference.is_ducking:
		spawn_treasure()

func check_player_is_crouched(player) -> bool:
	if player.is_ducking:
		return true
	else:
		return false

func spawn_treasure():
	AudioManager.play_sound_effect(SFX_SECRT_ITEM, "SFX", -10)
	triggered = true
	if not treasure_secret or not ITEM_DROP_SCENE: return
	
	var tween = create_tween()
	fake_treasure.global_position = fake_treasure_spawn.global_position
	fake_treasure.show()
	tween.tween_property(fake_treasure, "global_position", fake_treasure_target.global_position, 1)
	await get_tree().create_timer(1).timeout
	var drop_instance = ITEM_DROP_SCENE.instantiate()
	if "item_resource" in drop_instance:
		drop_instance.item_resource = treasure_secret
	get_tree().current_scene.add_child.call_deferred(drop_instance)
	fake_treasure.hide()
	drop_instance.global_position = Vector2(fake_treasure.global_position.x, fake_treasure.global_position.y)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not triggered:
		if not needs_player_crouched:
			spawn_treasure()
		else:
			entered = true
			player_reference = body

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		entered = false
