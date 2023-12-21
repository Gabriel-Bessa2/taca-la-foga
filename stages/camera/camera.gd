extends Camera2D

@export_group("Camera Bounds")
## the width of the level. Camera x position will always be between 0 and limit_width
@export_range(256, 25600, 16) var limit_width: int = 256
## the height of the level. Camera y position will always be between 0 and limit_height
@export_range(144, 14400, 16) var limit_height: int = 144
@export_group("Properties")
## player node to follow
@export var player: Player
## how long takes for the camera to get to player position
@export_range(1,100) var smoothness: int = 2
var proportions: Vector2 = Vector2(limit_width, limit_height)

@onready var hpRec: ColorRect = $Control/HPRec
@onready var moneyCount: Label = $Control/Money

func _ready():
	proportions = Vector2(limit_width, limit_height)
	if player == null:
		push_error("player undefined on camera scene")
	if proportions == Vector2(256, 144):
		push_warning("camera limits set to minimum, change it in camera node")
	lock_position()

func _physics_process(_delta):
	lock_position()
	hpRec.size.x = 76*(player.hp/player.HP_MAX)
	moneyCount.text = str(player.money) + "$"

func lock_position():
	var screenSize: Vector2 = Vector2(256, 144)
	position = position.lerp(player.position, 1.0/smoothness).clamp(screenSize/2,  proportions - (screenSize/2))
