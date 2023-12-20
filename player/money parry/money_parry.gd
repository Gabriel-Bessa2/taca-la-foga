class_name moneyParry
extends Hitbox

func _ready():
	damage = 10
	knockback = 1
	$Particles.emitting = true

func _destroy_timer():
	queue_free()

func enemy_collided(Body):
	if Body is Enemy:
		if Body.isAttacking:
			super.enemy_collided(Body)
			Body.moneyMultiplier = min(Body.moneyMultiplier + 1, 4)
