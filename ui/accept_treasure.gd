extends Button


func _on_Button_pressed():
	Game.emit_signal("accept_treasure")
