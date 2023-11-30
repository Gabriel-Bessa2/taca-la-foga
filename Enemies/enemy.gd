class_name Enemy
extends CharacterBody2D

var health: int
var moneyDrop: int
var moneyMultiplier: int = 1
var isAttacking: bool = false
var state: String

func damage(damageTaken: int):
	health = max(health - damageTaken, 0)
	if health == 0:
		state = "dead"
	else:
		state = "hurt"
