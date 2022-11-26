extends TextureRect

var outline_shader = preload("res://shaders/friend_outline.gdshader")

func _ready():
	material.set_shader_param("line_color", Color.aqua)
	material.set_shader_param("line_thickness", 9.0)
	Game.connect("highlight_friend", self, "highlight")

func highlight(v):
	if v:
		material.shader = outline_shader
	else:
		material.shader = null

func bump():
	margin_top = -50
	
func unbump():
	margin_top = 0
	
