extends Area


func _ready():
	pass

func set_translation(glob):
	global_translation = glob
	
func _on_Area_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton && event.button_index == 1:
		if event.pressed:
			Game.emit_signal("start_drag", self)


func _on_Area_mouse_entered():
	Game.emit_signal("start_hover", self)


func _on_Area_mouse_exited():
	Game.emit_signal("end_hover", self)
	pass # Replace with function body.
