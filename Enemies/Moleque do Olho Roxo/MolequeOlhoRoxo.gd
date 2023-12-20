class_name MolequeOlhoRoxo
extends Enemy

@onready var hit_area = $HitArea
@onready var sprite_2d = $HitArea/Sprite2D
@onready var animPlayer: AnimationPlayer = $AnimationPlayer
@onready var raycast_2d = $RayCast2D
@onready var attack_time = $AttackTimer
 
@export var ammo : PackedScene


func _ready():
	super()
	health = 100
	moneyDrop = 10
	
	
func _physics_process(delta):
	
	var player_distance = position.distance_to(target.position)
	#print(current_state)
	raycast_2d.target_position = to_local(target.position)			
	match current_state:
		ENEMY_STATES.IDLE:
			animPlayer.play("idle")
			velocity = Vector2.ZERO
			
			if(player_distance < sight_range and raycast_2d.get_collider() == target 
											 and attack_time.is_stopped() 
											 and canAttack):
				change_state(ENEMY_STATES.ATTACKING)
			elif(player_distance < sight_range):
				change_state(ENEMY_STATES.FOLLOWING)
		
		ENEMY_STATES.FOLLOWING:
			animPlayer.play("walk")
			handle_navigation()
			
			if(player_distance < sight_range and raycast_2d.get_collider() == target 
											 and attack_time.is_stopped()
											 and canAttack):
				change_state(ENEMY_STATES.ATTACKING)
			elif(player_distance < sight_range and player_distance <= attack_range):
				change_state(ENEMY_STATES.IDLE)
		ENEMY_STATES.DEAD:
			queue_free()
			velocity = Vector2.ZERO
			
		ENEMY_STATES.HURT:
			animPlayer.play("hurt")	
			if randi() % 15 == 1:
				velocity = speed*Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
				look_at(position + velocity)		
		ENEMY_STATES.ATTACKING:
			animPlayer.play("atck")			
			velocity = Vector2.ZERO		
			isAttacking = true	
			
			
	
	move_and_slide()
			
func _shoot():
	var bullet = ammo.instantiate()
	bullet.position = position
	bullet.direction = position.direction_to(target.position)
	get_tree().current_scene.add_child(bullet)



