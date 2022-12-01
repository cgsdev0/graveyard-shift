extends Button

var dead = false
func _on_Button_pressed():
	if dead:
		return
	dead = true
	Game.emit_signal("accept_treasure")
