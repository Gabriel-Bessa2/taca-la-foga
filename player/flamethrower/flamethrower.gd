class_name Flamethrower
extends Hitbox

@export var SPEED : float = 2.5
var direction : Vector2

func _ready():
	damage = 1
	knockback = 1
	direction += Vector2(randf_range(-0.1, 0.1), randf_range(-0.1, 0.1))

func _physics_process(_delta):
	position += direction*SPEED

func _destroy_timer():
	queue_free()
