class_name Player
extends CharacterBody2D

@onready var flamethrowerResource: Resource = preload("res://player/flamethrower/flamethrower.tscn")
@onready var moneyparryResource: Resource = preload("res://player/money parry/money_parry.tscn")

@onready var Sprite: Sprite2D = $Sprite
@onready var AnimPlayer: AnimationPlayer = $AnimationPlayer

@export var WALK_SPEED: float = 150
@export var FLAMETHROWER_WALK_SPEED: float = 50
@export var WALK_ACCELERATION: float = 0.2

enum PLAYER_STATES {MOVE, FIRE, CASH, HURT, DEAD}
const HP_MAX: int = 10
var state: PLAYER_STATES = PLAYER_STATES.MOVE
var hp: int = HP_MAX

var inputDirection: Vector2 = Vector2.ZERO
var inputFlamethrower: bool = false
var inputMoneyparry: bool = false
var aimDirection : Vector2 = Vector2.LEFT
var aimTargetDirection : Vector2 = Vector2.LEFT

func _physics_process(_delta):
	get_input()
	
	match state:
		PLAYER_STATES.MOVE:
			velocity = lerp(velocity, WALK_SPEED*inputDirection, WALK_ACCELERATION)
			
			if inputDirection.length() > 0:
				AnimPlayer.play("walk")
			else:
				AnimPlayer.play("idle")
			
			if inputMoneyparry:
				state = PLAYER_STATES.CASH
			elif inputFlamethrower:
				state = PLAYER_STATES.FIRE
				
		PLAYER_STATES.FIRE:
			velocity = lerp(velocity, FLAMETHROWER_WALK_SPEED*inputDirection, WALK_ACCELERATION)
			
			if inputDirection.length() > 0:
				AnimPlayer.play("walk_slow")
			else:
				AnimPlayer.play("idle")
			
			var flamethrowerInstance: Flamethrower = flamethrowerResource.instantiate()
			flamethrowerInstance.position = position + aimDirection*8
			flamethrowerInstance.direction = aimDirection
			flamethrowerInstance.rotation_degrees = randi_range(0, 360)
			get_tree().current_scene.add_child(flamethrowerInstance)
			
			if !inputFlamethrower:
				state = PLAYER_STATES.MOVE
			
		PLAYER_STATES.CASH:
			AnimPlayer.play("parry")
			velocity = velocity.lerp(Vector2.ZERO, WALK_ACCELERATION)
			
		PLAYER_STATES.DEAD:
			velocity = Vector2.ZERO
	
	move_and_slide()

func get_input():
	inputFlamethrower = Input.is_action_pressed("flamethrower")
	inputMoneyparry = Input.is_action_just_pressed("cash_parry")
	
	inputDirection.x = Input.get_axis("left", "right")
	inputDirection.y = Input.get_axis("up","down")
	inputDirection = inputDirection.normalized()
	
	if inputDirection.length() != 0 and !inputFlamethrower:
		aimTargetDirection = inputDirection
	
	aimDirection = lerp(aimDirection, aimTargetDirection, 0.4)
	Sprite.rotation = aimDirection.angle()

func gethit(damage: int):
	hp = max(hp - damage, 0)
	if hp == 0:
		AnimPlayer.play("dead")
		state = PLAYER_STATES.DEAD


func _on_death_reset_timer_timeout():
	get_tree().reload_current_scene()

func change_state(stateToChange: PLAYER_STATES):
	state = stateToChange

func instance_money_parry():
	var moneyparryInstance = moneyparryResource.instantiate()
	add_child(moneyparryInstance)
