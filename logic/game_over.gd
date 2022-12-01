extends Label

var dead_switch = false
func _process(delta):
	if dead_switch || !OS.is_debug_build():
		return
	if Input.is_key_pressed(KEY_1):
		if Game.level > 0:
			Game.level -= 1
		Game.emit_signal("reset")
		Game.emit_signal("change_scene", "res://main.tscn")
		dead_switch = true
	elif Input.is_key_pressed(KEY_2):
		Game.emit_signal("reset")
		Game.emit_signal("change_scene", "res://main.tscn")
		dead_switch = true
	elif Input.is_key_pressed(KEY_3):
		if Game.level < Game.levels.size() - 1:
			Game.level += 1
		Game.emit_signal("reset")
		Game.emit_signal("change_scene", "res://main.tscn")
		dead_switch = true
	elif Input.is_key_pressed(KEY_DELETE):
		if Input.is_key_pressed(KEY_SHIFT):
			Game.skip_to_inventory = true
		Game.emit_signal("reset")
		Game.emit_signal("change_scene", "res://shop.tscn")
		dead_switch = true
		
		
	if Input.is_action_just_pressed("restart") && visible:
		Game.reset_money()
		Game.emit_signal("reset")
		Game.emit_signal("change_scene", "res://main.tscn")
