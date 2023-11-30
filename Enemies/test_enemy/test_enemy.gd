class_name TestEnemy
extends Enemy

func _ready():
	health = 100
	moneyDrop = 10
	isAttacking = true

func _process(_delta):
	print_debug(health)
	if state == "dead":
		print_debug(moneyDrop*moneyMultiplier)
		queue_free()
