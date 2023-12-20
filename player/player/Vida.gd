extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_hp_changed(player) -> void:
	var lifeBar = $bar
	lifeBar.size.x = 72 * player.hp / player.HP_MAX
