class_name ManoGuarda
extends Enemy

@onready var hit_area = $HitArea
@onready var sprite_2d = $HitArea/Sprite2D

func _ready():
	super()
	health = 100
	moneyDrop = 10

func _physics_process(_delta):
	super(_delta)
		
	#print_debug(health)
	match current_state:
		ENEMY_STATES.ALIVE:
			pass
		ENEMY_STATES.FOLLOWING:
			hit_area.visible = false
			#hit_area.monitorable = false
		ENEMY_STATES.DEAD:
			pass
		ENEMY_STATES.HURT:
			queue_free()
		ENEMY_STATES.LOAD_ATTACK:
			hit_area.visible = true
			#hit_area.monitorable = true
		ENEMY_STATES.ATTACKING:
			#hit_area.layer
			pass

func _on_timer_timeout():
	current_state = ENEMY_STATES.ATTACKING

func _on_hit_area_body_entered(body):
	if(body is Player):
		body.gethit(dmg)
