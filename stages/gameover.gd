extends Node2D

func _process(_delta):
	if Input.is_action_pressed("flamethrower"):
		get_tree().change_scene_to_file("res://stages/menu.tscn")
