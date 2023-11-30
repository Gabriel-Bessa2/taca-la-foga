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
			damage *= 2
			Body.moneyMultiplier = min(Body.moneyMultiplier + 1, 4)
			
		super.enemy_collided(Body)
