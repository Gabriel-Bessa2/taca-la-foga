class_name Hitbox
extends Area2D

@export var damage: int = 0
@export var knockback: float = 0

func enemy_collided(body):
	if body is Enemy:
		body.velocity = knockback*(body.position - position)
		body.damage(damage)
