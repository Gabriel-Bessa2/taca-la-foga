class_name MolequeOlhoRoxo
extends Enemy

@onready var hit_area = $HitArea
@onready var sprite_2d = $HitArea/Sprite2D
@onready var animPlayer: AnimationPlayer = $AnimationPlayer

func _ready():
	super()
	health = 100
	moneyDrop = 10
	
func _process(delta):
	super(delta)
	match current_state:
		ENEMY_STATES.IDLE:
			animPlayer.play("idle")
			pass
		ENEMY_STATES.FOLLOWING:
			animPlayer.play("walk")
			pass
		ENEMY_STATES.DEAD:
			queue_free()
		ENEMY_STATES.HURT:
			animPlayer.play("hurt")
			if randi() % 15 == 1:
				velocity = speed*Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
				look_at(position + velocity)
		ENEMY_STATES.ATTACKING:
			velocity = Vector2.ZERO
			animPlayer.play("atck")
