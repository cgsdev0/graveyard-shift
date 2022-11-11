extends Area


func _ready():
	pass


func _on_Area_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton && event.button_index == 1:
		if event.pressed:
			Game.emit_signal("start_drag", self)
