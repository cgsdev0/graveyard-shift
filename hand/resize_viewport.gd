extends Viewport

var min_ratio = 16.0 / 9.0

func _ready():
	OS.min_window_size = OS.window_size
	get_tree().get_root().connect("size_changed", self, "on_resize")
	VisualServer.set_debug_generate_wireframes(true)
	call_deferred("on_resize")
	
func _input(event):
	if OS.is_debug_build() && event is InputEventKey and Input.is_key_pressed(KEY_PAGEUP):
		var vp = $BoardViewport/Viewport
		vp.debug_draw = (vp.debug_draw + 1 ) % 4
		vp = $HandViewport/Viewport
		vp.debug_draw = (vp.debug_draw + 1 ) % 4


var last_margin = null
func on_resize():
	var v = get_tree().root.get_viewport().size
	if v.x / v.y < min_ratio:
		var margin = Vector2(0, v.y - v.x / min_ratio) / 2
		if margin != last_margin:
			get_parent().margin_top = margin.y
			set_size_override(true, Vector2(v.x, v.x / min_ratio), margin)
			last_margin = margin
	elif last_margin != null:
		last_margin = null
		get_parent().margin_top = 0
		set_size_override(false)
	$BoardViewport.margin_left = -$UI/RightBar.rect_size.x
	$HandViewport.margin_left = -$UI/RightBar.rect_size.x
