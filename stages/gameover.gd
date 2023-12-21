extends Node2D

@export var sceneToGo: PackedScene
var canReturn: bool = false

func _physics_process(_delta):
	if Input.is_action_pressed("flamethrower") and canReturn:
		print_debug("pressed")
		get_tree().change_scene_to_packed(sceneToGo)


func _on_cooldown_timer_timeout():
	canReturn = true
	print_debug("cooldown")
