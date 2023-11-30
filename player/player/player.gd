class_name Player
extends CharacterBody2D

@onready var flamethrowerResource: Resource = preload("res://player/flamethrower/flamethrower.tscn")
@onready var moneyparryResource: Resource = preload("res://player/money parry/money_parry.tscn")

@export var WALK_SPEED : float = 150
@export var FLAMETHROWER_WALK_SPEED : float = 50
@export var WALK_ACCELERATION : float = 0.2

var state : String = "move"

var inputDirection: Vector2 = Vector2.ZERO
var inputFlamethrower: bool = false
var inputMoneyparry: bool = false
var aimDirection : Vector2 = Vector2.LEFT
var aimTargetDirection : Vector2 = Vector2.LEFT

func _physics_process(_delta):
	get_input()
	
	match state:
		"move":
			velocity = lerp(velocity, WALK_SPEED*inputDirection, WALK_ACCELERATION)
			
			if inputMoneyparry:
				state = "cash"
			elif inputFlamethrower:
				state = "fire"
				
		"fire":
			velocity = lerp(velocity, FLAMETHROWER_WALK_SPEED*inputDirection, WALK_ACCELERATION)
			
			var flamethrowerInstance: Flamethrower = flamethrowerResource.instantiate()
			flamethrowerInstance.position = position
			flamethrowerInstance.direction = aimDirection
			flamethrowerInstance.rotation_degrees = randi_range(0, 360)
			get_tree().current_scene.add_child(flamethrowerInstance)
			
			if !inputFlamethrower:
				state = "move"
			
		"cash":
			#script temporario, é necessario um AnimationPlayer para definir
			#o timing em que a instancia será criada bem como o retorno para o estado "move"
			velocity = Vector2.ZERO#lerp(velocity, Vector2.ZERO, WALK_ACCELERATION)
			
			var moneyparryInstance = moneyparryResource.instantiate()
			add_child(moneyparryInstance)
			
			state = "move"
	
	move_and_slide()

func get_input():
	inputDirection.x = Input.get_axis("left", "right")
	inputDirection.y = Input.get_axis("up","down")
	inputDirection = inputDirection.normalized()
	
	if inputDirection.length() != 0:
		aimTargetDirection = inputDirection
	
	inputFlamethrower = Input.is_action_pressed("flamethrower")
	inputMoneyparry = Input.is_action_just_pressed("cash_parry")
	
	aimDirection = lerp(aimDirection, aimTargetDirection, 0.4)
