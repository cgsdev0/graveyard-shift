extends Token

var lure_range

var lure2 = preload("res://textures/tokens/lure_2.png")

func _ready():
	add_to_group("lures")
	var start_tween = Tween.new()
	add_child(start_tween)
	scale = Vector3(0, 1, 1)
	start_tween.interpolate_property(self, "scale", scale, Vector3(1,1,1),
	1.1, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	start_tween.start()
	set_tex()

func set_tex():
	if lure_range > 100:
		$token/Token.get_surface_material(2).albedo_texture = lure2
