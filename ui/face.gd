extends Spatial


var default_eye = preload("res://textures/ui/eye_2.png")
var happy_eye = preload("res://textures/ui/eye_1.png")

func _ready():
	Game.connect("you_win", self, "set_face_happy")
	pass

func set_rot(hori, vert):
	$head.rotation_degrees.y = lerp(-35.0, 5.0, hori)
	$head.rotation_degrees.x = lerp(-10.0, 5.0, vert)

func change_eye_texture(eye, texture):
	eye.material.set_shader_param("texture_albedo", texture)
	
func set_face_happy(): 
	$AnimationPlayer.play("happy_eyes")
	change_eye_texture($head/face/eye1, happy_eye)
	change_eye_texture($head/face/eye2, happy_eye)

func set_face_default(): 
	$AnimationPlayer.play("RESET")
	change_eye_texture($head/face/eye1, default_eye)
	change_eye_texture($head/face/eye2, default_eye)
