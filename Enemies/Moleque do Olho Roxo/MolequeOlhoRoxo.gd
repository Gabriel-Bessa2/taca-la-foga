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
	
func _physics_process(_delta):
	var player_distance = position.distance_to(target.position)
	raycast_2d.target_position = to_local(target.position)
	
	match current_state:
		"idle":
			animPlayer.play("idle")
			velocity = Vector2.ZERO
			
			if(player_distance < sight_range and raycast_2d.get_collider() == target 
											 and attack_time.is_stopped() 
											 and canAttack):
				change_state("attack")
			elif(player_distance < sight_range):
				change_state("follow")
		
		"follow":
			animPlayer.play("walk")
			handle_navigation()
			
			if(player_distance < sight_range and raycast_2d.get_collider() == target 
											 and attack_time.is_stopped()
											 and canAttack):
				change_state("attack")
			elif(player_distance < sight_range and player_distance <= attack_range):
				change_state("idle")
			
		"dead":
			queue_free()
			velocity = Vector2.ZERO
			
		"hurt":
			animPlayer.play("hurt")
			print_debug("ai ai ai")
			if randi() % 15 == 1:
				velocity = speed*Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
				look_at(position + velocity)
				
		"attack":
			animPlayer.play("atck")
			velocity = Vector2.ZERO
			isAttacking = true
			
	super(_delta)
	
func _shoot():
	var bullet = ammo.instantiate()
	bullet.position = position
	bullet.direction = position.direction_to(target.position)
	bullet.target = target
	bullet.damage = 4
	get_tree().current_scene.add_child(bullet)
