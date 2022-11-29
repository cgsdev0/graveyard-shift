extends Node


func _ready():
	pass

func _input(event):
	if event is InputEventMouseButton && event.pressed && event.button_index == 1:
		Game.emit_signal("change_scene", "res://menu.tscn")
	
