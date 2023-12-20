extends Area2D

var direction : Vector2
var speed : float  = 300
var target
var damage : int

func _physics_process(delta):
	position+= direction * speed * delta

func _destroy():
	queue_free()

func _on_screen_exited():
	_destroy()

	

func _on_body_entered(body):
	if(body is Player):
		body.gethit(damage)
		_destroy()
# Replace with function body.
