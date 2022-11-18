extends Control

var original_theme

func _ready():
	get_tree().get_root().connect("size_changed", self, "on_resize")
	call_deferred("on_resize")
	original_theme = theme.duplicate(true)
	
	var merged_shop_theme = Theme.new()
	merged_shop_theme.merge_with(original_theme)
	merged_shop_theme.merge_with($Shop.theme)
	$Shop.theme = merged_shop_theme

func scale_margin(original_margin, scale_factor):
	if original_margin == -1:
		return -1
	return original_margin * scale_factor

var min_sizes = {}
func scale_children(node, scale_factor):
	if node == $Shop:
		return
	for child in node.get_children():
		if child is Control:
			if child.rect_min_size != Vector2.ZERO:
				if !min_sizes.has(child.get_instance_id()):
					min_sizes[child.get_instance_id()] = child.rect_min_size
				child.rect_min_size = min_sizes[child.get_instance_id()] * scale_factor
		scale_children(child, scale_factor)

func on_resize():
	yield(get_tree().create_timer(0), "timeout")
	var v = get_viewport().size
	# TODO: this value should maybe come from somewhere else
	var scale_factor = min(v.x / 800.0, v.y / 450.0)
	
	for type in theme.get_font_types():
		for font in theme.get_font_list(type):
			var f = theme.get_font(font, type)
			f.size = int(original_theme.get_font(font, type).size * scale_factor)
	
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
	update()
func get_bottom_edge():
	return $"%BottomEdge"

func get_left_edge():
	return $"%LeftEdge"
	
func get_top_edge():
	return $"%TopEdge"
	
func get_right_bar():
	return $"%RightBar"
