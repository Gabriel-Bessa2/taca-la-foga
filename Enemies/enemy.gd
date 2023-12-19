class_name Enemy
extends CharacterBody2D

@export var health: int = 10
@export var moneyDrop: int = 1
@export var dmg: int = 1
@export var speed: int = 50
var moneyMultiplier: int = 1

#Attacking
@onready var attackTimer: Timer = $AttackTimer
var isAttacking: bool = false
var canAttack: bool = true

#state machine
enum ENEMY_STATES {IDLE, FOLLOWING, DEAD, HURT, LOAD_ATTACK, ATTACKING}
var current_state: ENEMY_STATES

#movement
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@export var target: Player
@export var sight_range: float = 100
@export var attack_range: float = 30

#immunity
@onready var immunityTimer: Timer = $ImmunityTimer
var immune: bool = false

func _ready():
	current_state = ENEMY_STATES.IDLE
	navigation_agent.path_desired_distance = attack_range
	navigation_agent.target_desired_distance = attack_range

func _process(_delta):
	match current_state:
		ENEMY_STATES.IDLE:
			pass
		ENEMY_STATES.FOLLOWING:
			pass
		ENEMY_STATES.DEAD:
			pass
		ENEMY_STATES.HURT:
			pass
		ENEMY_STATES.ATTACKING:
			pass

func _physics_process(_delta):
	var player_distance = position.distance_to(target.position)
	
	match current_state:
		ENEMY_STATES.IDLE:
			velocity = Vector2.ZERO
			
			if(player_distance < sight_range and player_distance <= attack_range and canAttack):
				change_state(ENEMY_STATES.ATTACKING)
			elif(player_distance < sight_range):
				change_state(ENEMY_STATES.FOLLOWING)
		
		ENEMY_STATES.FOLLOWING:
			handle_navigation()
			
			if(player_distance < sight_range and player_distance <= attack_range and canAttack):
				change_state(ENEMY_STATES.ATTACKING)
			elif(player_distance < sight_range and player_distance <= attack_range):
				change_state(ENEMY_STATES.IDLE)
		ENEMY_STATES.DEAD:
			velocity = Vector2.ZERO
			
		ENEMY_STATES.HURT:
			pass
		ENEMY_STATES.ATTACKING:
			pass
	
	move_and_slide()

func handle_navigation() -> void:
	call_deferred("actor_setup")
	if (!navigation_agent.is_navigation_finished()):
		var current_agent_position: Vector2 = global_position
		var next_path_position: Vector2 = navigation_agent.get_next_path_position()

		velocity = current_agent_position.direction_to(next_path_position) * speed
		aim_at_player()

func actor_setup():
	await get_tree().physics_frame
	set_movement_target(target.position)

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target
	
func end_attack():
	canAttack = false
	isAttacking = false
	attackTimer.start()
	current_state = ENEMY_STATES.IDLE

func change_state(stateToChange: ENEMY_STATES):
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
		change_state(ENEMY_STATES.DEAD)
	else:
		change_state(ENEMY_STATES.HURT)
