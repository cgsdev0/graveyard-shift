extends Sprite

var outline_shader = preload("res://shaders/friend_outline.gdshader")

func _ready():
	material.set_shader_param("line_color", Color.aqua)
	material.set_shader_param("line_thickness", 9.0)
	Game.connect("highlight_friend", self, "highlight")

func _process(delta):
	var v = get_viewport().size
	var scale_factor = min(v.x / 800.0, v.y / 450.0) * 0.22
	scale = Vector2(scale_factor, scale_factor) 
	
func highlight(v):
	if v:
		material.shader = outline_shader
	else:
		material.shader = null

func bump():
	pass
	# margin_top = -50
	
func unbump():
	pass 
	# margin_top = 0
	
