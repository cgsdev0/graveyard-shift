extends Spatial


func _ready():
	pass

func set_rot(hori, vert):
	$head.rotation_degrees.y = lerp(-35.0, 5.0, hori)
	$head.rotation_degrees.x = lerp(-10.0, 5.0, vert)
