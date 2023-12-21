class_name Enemy
extends CharacterBody2D

@export var health: int = 10
@export var moneyDrop: int = 5
@export var dmg: int = 1
@export var speed: int = 50
var moneyMultiplier: int = 1

@onready var sprite: Sprite2D = $Sprite2D

#Attacking
@onready var attackTimer: Timer = $AttackTimer
var isAttacking: bool = false
var canAttack: bool = true

##state machine
var current_state: String

#movement
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@export var target: Player
@export var sight_range: float = 100
@export var attack_range: float = 30
@export var flee_range: float = -1

#immunity
@onready var immunityTimer: Timer = $ImmunityTimer
var immune: bool = false

func _ready():
	current_state = "idle"
	navigation_agent.path_desired_distance = attack_range
	navigation_agent.target_desired_distance = attack_range

func _physics_process(_delta):
	if immune:
		if randi() % 2 == 1:
			sprite.modulate = Color(1, 0, 0)
		else:
			sprite.modulate = Color(1, 1, 0)
	else:
		sprite.modulate = Color(1, 1, 1)
	move_and_slide()

func handle_navigation() -> void:
	call_deferred("actor_setup")
	#print(navigation_agent.is_navigation_finished())
	#if (navigation_agent.is_navigation_finished() && flee_range != -1):
		#change_state(ENEMY_STATES.ATTACKING)
		#
	if (!navigation_agent.is_navigation_finished()):
		var current_agent_position: Vector2 = global_position
		var next_path_position: Vector2 = navigation_agent.get_next_path_position()

		velocity = current_agent_position.direction_to(next_path_position) * speed
		aim_at_player()

func actor_setup():
	await get_tree().physics_frame
	
	var player_distance: float = position.distance_to(target.position)
	var direction: Vector2 = position.direction_to(target.position)
	#print(direction)
	if(flee_range != -1 && player_distance < flee_range):
		#print("A1")
		var safe_distance: float = flee_range - player_distance
		var flee_position: Vector2 = Vector2((position.x - safe_distance if direction.x > 0 else position.x + safe_distance), (position.y - safe_distance if direction.y > 0 else position.y + safe_distance))
		
		navigation_agent.path_desired_distance = 4
		navigation_agent.target_desired_distance = 4
		set_movement_target(flee_position)
	else:
		navigation_agent.path_desired_distance = attack_range
		navigation_agent.target_desired_distance = attack_range
		set_movement_target(target.position)

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target
	
func end_attack():
	canAttack = false
	isAttacking = false
	attackTimer.start()
	current_state = "idle"

func change_state(stateToChange: String):
	current_state = stateToChange

func aim_at_player():
	look_at(target.position)

func attack_cooldown_out():
	canAttack = true

func immunity_timeout():
	immune = false

func damage(damageTaken: int):
	health = max(health - damageTaken, 0)
	immune = true
	immunityTimer.start()
	
	if health == 0:
		target.money += moneyDrop*moneyMultiplier
		change_state("dead")
	elif !isAttacking:
		change_state("hurt")
