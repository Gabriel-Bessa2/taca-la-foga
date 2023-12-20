class_name Boss
extends Enemy

@onready var animPlayer: AnimationPlayer = $AnimationPlayer

func _ready():
	super()
	health = 500
	moneyDrop = 10
	
func _physics_process(_delta):
	var player_distance = position.distance_to(target.position)
	
	match current_state:
		"idle":
			velocity = Vector2.ZERO
			animPlayer.play("idle")
			
			if(player_distance < sight_range):
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
				aim_at_player()
			elif animPlayer.current_animation_position == 0.7:
				velocity = position.direction_to(target.position)*speed*2
	
	super(_delta)

func _on_hit_area_body_entered(body):
	if(body is Player):
		body.gethit(dmg)
