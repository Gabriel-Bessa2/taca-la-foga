class_name Enemy
extends CharacterBody2D

@export var health: int = 10
@export var moneyDrop: int = 1
@export var dmg: int = 1
@export var speed: int = 50
var moneyMultiplier: int = 1
var isAttacking: bool = false

enum ENEMY_STATES {ALIVE, FOLLOWING, DEAD, HURT, LOAD_ATTACK, ATTACKING}
var current_state: ENEMY_STATES

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@export var target: Player

@export var sight_range: float = 100
@export var attack_range: float = 30
@export var flee_range: float = -1

@onready var timer: Timer = $Timer

func _ready():
	current_state = ENEMY_STATES.ALIVE
	navigation_agent.path_desired_distance = attack_range
	navigation_agent.target_desired_distance = attack_range

func _process(delta):
	match current_state:
		ENEMY_STATES.ALIVE:
			pass
		ENEMY_STATES.FOLLOWING:
			pass
		ENEMY_STATES.DEAD:
			pass
		ENEMY_STATES.HURT:
			pass
		ENEMY_STATES.ATTACKING:
			pass

func _physics_process(delta):
	match current_state:
		ENEMY_STATES.ALIVE:
			if(position.distance_to(target.position) < sight_range):
				current_state = ENEMY_STATES.FOLLOWING
		ENEMY_STATES.FOLLOWING:
			handle_navigation()
		ENEMY_STATES.DEAD:
			pass
		ENEMY_STATES.HURT:
			pass
		ENEMY_STATES.LOAD_ATTACK:
			pass
		ENEMY_STATES.ATTACKING:
			#print("Attack")
			current_state = ENEMY_STATES.FOLLOWING

func handle_navigation() -> void:
	call_deferred("actor_setup")
	#print(navigation_agent.is_navigation_finished())
	if (!navigation_agent.is_navigation_finished()):
		var current_agent_position: Vector2 = global_position
		var next_path_position: Vector2 = navigation_agent.get_next_path_position()

		velocity = current_agent_position.direction_to(next_path_position) * speed
		look_at(target.position)
		
		move_and_slide()
	elif (navigation_agent.is_target_reached()):
		current_state = ENEMY_STATES.LOAD_ATTACK
		timer.start()

func actor_setup():
	await get_tree().physics_frame
	
	var player_distance: float = position.distance_to(target.position)
	var direction: Vector2 = position.direction_to(target.position)
	#print(direction)
	if(flee_range != -1 && player_distance < flee_range):
		print("A1")
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

func damage(damageTaken: int):
	health = max(health - damageTaken, 0)
	if health == 0:
		current_state = ENEMY_STATES.DEAD
	else:
		current_state = ENEMY_STATES.HURT
