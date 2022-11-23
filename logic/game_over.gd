extends Label

func game_over():
	visible = true
	
func _ready():
	Game.connect("game_over", self, "game_over")
	pass

var dead_switch = false
func _process(delta):
	if dead_switch:
		return
	if Input.is_key_pressed(KEY_1):
		Game.level = 0
		Game.emit_signal("reset")
		Game.emit_signal("change_scene", "res://main.tscn")
		dead_switch = true
	elif Input.is_key_pressed(KEY_2):
		Game.level = 1
		Game.emit_signal("reset")
		Game.emit_signal("change_scene", "res://main.tscn")
		dead_switch = true
	elif Input.is_key_pressed(KEY_3):
		Game.level = 2
		Game.emit_signal("reset")
		Game.emit_signal("change_scene", "res://main.tscn")
		dead_switch = true
		
		
	if Input.is_action_just_pressed("restart") && visible:
		Game.reset_money()
		Game.emit_signal("reset")
		Game.emit_signal("change_scene", "res://main.tscn")
