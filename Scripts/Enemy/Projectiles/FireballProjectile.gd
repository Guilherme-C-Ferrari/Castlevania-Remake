extends BaseEnemy

func _ready() -> void:
	super()
	hp = 1
	experience = 100
	if randf() < 0.75:
		damage = 2
	else:
		damage = 4
	move_speed = 35
	if hit_box:
		hit_box.body_entered.connect(_on_hitbox_body_entered)

func _physics_process(_delta: float) -> void:
	super._physics_process(_delta)
	velocity.x = walk_direction * move_speed
	handle_animation()
	move_and_slide()
	
	var collided = move_and_slide()
	if collided or is_on_wall() or is_on_floor():
		projectile_struck()

func handle_animation() -> void:
	var move_direction = velocity.normalized()
	if move_direction.x > 0.0:
		sprite.flip_h = false
	elif move_direction.x < 0.0:
		sprite.flip_h = true

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		projectile_struck()

func projectile_struck() -> void:
	sprite.set_deferred("visible", false)
	hit_box.get_child(0).set_deferred("disabled", true)
	queue_free()

func drop_item() -> void:
	pass
