extends Control

var original_theme

func _ready():
	get_tree().get_root().connect("size_changed", self, "on_resize")
	call_deferred("on_resize")
	original_theme = theme.duplicate(true)

func scale_margin(original_margin, scale_factor):
	if original_margin == -1:
		return -1
	return original_margin * scale_factor

var min_sizes = {}
func scale_children(node, scale_factor):
	for child in node.get_children():
		if child is Control:
			if child.rect_min_size != Vector2.ZERO:
				print(child)
				if !min_sizes.has(child.get_instance_id()):
					min_sizes[child.get_instance_id()] = child.rect_min_size
				child.rect_min_size = min_sizes[child.get_instance_id()] * scale_factor
		scale_children(child, scale_factor)

func on_resize():
	var v = get_viewport().size
	# TODO: this value should maybe come from somewhere else
	var scale_factor = v.x / 800.0
	var font_size = int(16.0 * scale_factor)
	theme.get_font("font", "Label").size = font_size
	theme.get_font("font", "BigLabel").size = font_size * 2
	
	# this should really be an engine feature
	scale_children(self, scale_factor)
	
	for type in theme.get_constant_types():
		for constant in theme.get_constant_list(type):
			theme.set_constant(constant, type, original_theme.get_constant(constant, type) * scale_factor)
			
			
	for type in theme.get_stylebox_types():
		for n in theme.get_stylebox_list(type):
			var stylemap = theme.get_stylebox(n, type)
			var og_stylemap = original_theme.get_stylebox(n, type)
			stylemap.content_margin_bottom = scale_margin(og_stylemap.content_margin_bottom, scale_factor)
			stylemap.content_margin_top = scale_margin(og_stylemap.content_margin_top, scale_factor)
			stylemap.content_margin_left = scale_margin(og_stylemap.content_margin_left, scale_factor)
			stylemap.content_margin_right = scale_margin(og_stylemap.content_margin_right, scale_factor)
			
func get_bottom_edge():
	return $"%BottomEdge"

func get_left_edge():
	return $"%LeftEdge"
	
func get_top_edge():
	return $"%TopEdge"
	
func get_right_bar():
	return $"%RightBar"
