extends Label

func game_over():
	visible = true
	
func _ready():
	Game.connect("game_over", self, "game_over")
	pass

func _process(delta):
	if Input.is_key_pressed(KEY_1):
		Game.level = 0
		Game.emit_signal("reset")
		get_tree().reload_current_scene()
	elif Input.is_key_pressed(KEY_2):
		Game.level = 1
		Game.emit_signal("reset")
		get_tree().reload_current_scene()
	elif Input.is_key_pressed(KEY_3):
		Game.level = 2
		Game.emit_signal("reset")
		get_tree().reload_current_scene()
		
		
	if Input.is_action_just_pressed("restart") && visible:
		Game.reset_money()
		Game.emit_signal("reset")
		get_tree().reload_current_scene()
