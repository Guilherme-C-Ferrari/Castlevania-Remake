extends Resource
class_name Weapon

enum Type_Item {
	WEAPON,
	HEART,
	POINTS,
	HEAL,
	SPECIAL
}

@export var name: String
@export var heart_cost: int = 1
@export var item_points: int = 0
@export var despawn_time: int = 5
@export var item_type: Type_Item
@export var sprite: Texture
@export var animatedSprite: SpriteFrames
@export var collision_size: Vector2 = Vector2(16,16)
