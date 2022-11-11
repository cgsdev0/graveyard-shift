extends Spatial


func _process(delta):
	var mouse = get_viewport().get_mouse_position()
	global_translation = get_viewport().get_camera().project_position(mouse, 5)
	pass
