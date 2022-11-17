extends Spatial


var dist_from_camera = 5
func _process(delta):
	var mouse = get_parent().get_mouse_position()
	global_translation = get_viewport().get_camera().project_position(mouse, dist_from_camera)
