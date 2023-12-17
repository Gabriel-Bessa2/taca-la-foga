extends Node2D

@export_range(256, 25600, 16) var width: int = 256
@export_range(144, 14400, 16) var height: int = 144
@export var player: Player
@export_range(1,100) var smoothness: int = 2
var proportions: Vector2 = Vector2(width, height)

func _ready():
	proportions = Vector2(width, height)
	if player == null:
		push_error("player undefined on camera scene")
	lock_position()

func _physics_process(_delta):
	lock_position()

func lock_position():
	var screenSize: Vector2 = Vector2(256, 144)
	position = position.lerp(player.position, 1.0/smoothness).clamp(screenSize/2,  proportions - (screenSize/2))
