extends Label

func game_over():
	visible = true
	
func _ready():
	Game.connect("game_over", self, "game_over")
	pass

func _process(delta):
	if Input.is_action_just_pressed("restart") && visible:
		Game.emit_signal("reset")
		get_tree().reload_current_scene()
