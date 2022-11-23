extends ShopCard3D

var cam
var done_spinning = false
var exiting = false

var exit_time = 0.0

func _ready():
	cam = get_viewport().get_camera()
	global_rotation = Vector3.ZERO
	global_translation = cam.project_position(get_viewport().size / 2, 10.0)
	hover_time = -1.0
	$Card.enable_glow()
	Game.connect("accept_treasure", self, "on_accept_treasure")

func on_accept_treasure():
	exiting = true
	tween.interpolate_property(self, "global_rotation", global_rotation, Vector3(0, PI, 0), 0.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "scale", scale, Vector3(0, 0, 0), 1.0)
	tween.start()
	
func do_process(delta):
	if exiting:
		exit_time += delta
	hover_time += delta
	var screen_size = get_viewport().size
	var screen_center = screen_size / 2
	global_translation = cam.project_position(screen_center, (15) * screen_size.x / 800.0)
	if exiting:
		return
	global_rotation = Vector3.ZERO
	
	$Card.adjust_glow(lerp(0, 0.1, ease(clamp((hover_time - 1.3) / 12.0, 0, 1), 0.2)))
	if !done_spinning:
		var start = Vector3(0, -15, 0)
		global_translation += lerp(start, Vector3.ZERO, ease(clamp(hover_time / 2.0, 0, 1), 0.4))
		rotate_y(lerp(30, 0, ease(clamp(hover_time / 1.7, 0, 1), 0.6)))
		if hover_time > 2.0:
			done_spinning = true
		return
		
	var target = clamp((screen_center.x - get_viewport().get_mouse_position().x) / screen_size.x, -1, 1)
	rotate(Vector3(0, 0.8, 0.2).normalized(), lerp(0, target, ease(clamp((hover_time - 2.5) * 2.0, 0, 1), 0.5)))
	

