class_name ManoGuarda
extends Enemy

@onready var hit_area = $HitArea
@onready var sprite_2d = $HitArea/Sprite2D
@onready var animPlayer: AnimationPlayer = $AnimationPlayer

#state machine
#enum ENEMY_STATES {IDLE, FOLLOWING, DEAD, HURT, LOAD_ATTACK, ATTACKING}
#var current_state: ENEMY_STATES

func _ready():
	super()
	health = 100
	moneyDrop = 10

func _physics_process(_delta):
	var player_distance = position.distance_to(target.position)
	
	match current_state:
		"idle":
			animPlayer.play("idle")
			velocity = Vector2.ZERO
			if(player_distance < sight_range and player_distance <= attack_range and canAttack && flee_range == -1):
				change_state("attack")
			elif(player_distance < sight_range):
				change_state("follow")
				
		"follow":
			animPlayer.play("walk")
			handle_navigation()
			
			if(player_distance < sight_range and player_distance <= attack_range and canAttack && flee_range == -1):
				change_state("attack")
			elif(player_distance < sight_range and player_distance <= attack_range):
				change_state("idle")
			
		"dead":
			velocity = Vector2.ZERO
			queue_free()
			
		"hurt":
			animPlayer.play("hurt")
			if randi() % 15 == 1:
				velocity = speed*Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
				look_at(position + velocity)
				
		"attack":
			velocity = Vector2.ZERO
			isAttacking = true
			animPlayer.play("atck")
	
	super(_delta)

func _on_hit_area_body_entered(body):
	if(body is Player):
		body.gethit(dmg)
