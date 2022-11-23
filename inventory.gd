extends Node

var controller

func _on_SkipButton_pressed():
	Game.level += 1
	Game.emit_signal("reset")
	get_tree().change_scene("res://main.tscn")
