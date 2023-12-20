class_name Boss
extends Enemy

var start: bool = true
var playerDirection: Vector2

@onready var animPlayer: AnimationPlayer = $AnimationPlayer

func _ready():
	super()
	health = 200
	moneyDrop = 10
	attack_range = 19
	
func _physics_process(_delta):
	var player_distance: float = position.distance_to(target.position)
	
	if current_state == "attack" or current_state == "dash":
		isAttacking = true
	else:
		isAttacking = false
	
	match current_state:
		"idle":
			velocity = Vector2.ZERO
			animPlayer.play("idle")
			
			if(player_distance < sight_range or start):
				start = true
				change_state("follow")
			
		"follow":
			handle_navigation()
			animPlayer.play("walk")
			
			if canAttack:
				if player_distance > 20:
					change_state("dash")
				else:
					change_state("attack")
				
		"dead":
			queue_free()
			
		"hurt":
			change_state("idle")
			
		"attack":
			velocity = Vector2.ZERO
			animPlayer.play("atck")
			
		"dash":
			animPlayer.play("dash")
			if animPlayer.current_animation_position < 0.7:
				velocity = Vector2.ZERO
				playerDirection = position.direction_to(target.position)
				aim_at_player()
			else:
				velocity = playerDirection * speed * 3
	
	super(_delta)

func _on_hit_area_body_entered(body):
	if(body is Player):
		body.gethit(dmg)
		if current_state == "dash":
			change_state("idle")
