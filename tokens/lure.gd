extends Token

var lure_range

func _ready():
	add_to_group("lures")
	var start_tween = Tween.new()
	add_child(start_tween)
	scale = Vector3(0, 1, 1)
	start_tween.interpolate_property(self, "scale", scale, Vector3(1,1,1),
	1.1, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	start_tween.start()
