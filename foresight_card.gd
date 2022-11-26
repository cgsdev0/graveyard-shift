extends ShopCard3D

var index = 0

func _ready():
	var cam = get_viewport().get_camera()
	var v = get_viewport().size
	global_rotation = cam.global_rotation
	rotate_object_local(Vector3.UP, PI / 2)
	global_translation = cam.project_position(Vector2.ZERO, 5.0)
	var target_translation = cam.project_position(Vector2(v.x / 2 + (index - 1) * v.x / 5.8, v.y / 3), 5.0)
	scale = Vector3(0.15, 0.15, 0.15)
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(self, "global_translation", 
		global_translation,
		target_translation,
		0.4,
		Tween.TRANS_QUAD,
		Tween.EASE_OUT)
	tween.interpolate_property(self, "global_transform:basis", 
		global_transform.basis,
		cam.global_transform.scaled(scale).rotated(cam.global_transform.basis.y, -PI / 2).basis,
		0.5,
		Tween.TRANS_QUAD,
		Tween.EASE_OUT,
		0.4)
	tween.start()
	yield(tween, "tween_all_completed")
	$AnimationPlayer.play("float")
	
func do_process(delta):
	pass
