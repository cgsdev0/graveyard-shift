extends Control

func _ready():
	get_tree().get_root().connect("size_changed", self, "on_resize")
	Game.connect("prep_new_turn", self, "start_new_turn")
	call_deferred("on_resize")
	if !Game.original_theme:
		Game.original_theme = theme.duplicate(true)
	
	set_turns(Game.turns)
	
func start_new_turn():
	Game.turns -= 1
	set_turns(Game.turns)
	yield($"%TurnsProgress/Tween", "tween_completed")
	if Game.turns == 0:
		Game.emit_signal("you_win")
		yield(Game, "daylight_animation_done")
		$YouWin/AnimationPlayer.play("victory")
	else:
		Game.emit_signal("deal_new_turn")
	
func scale_margin(original_margin, scale_factor):
	if original_margin == -1:
		return -1
	return original_margin * scale_factor

var min_sizes = {}
func scale_children(node, scale_factor):
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
			print(font," ", type, " ", f)
			f.size = int(Game.original_theme.get_font(font, type).size * scale_factor)
	
	# this should really be an engine feature
	scale_children(self, scale_factor)
	
	for type in theme.get_constant_types():
		for constant in theme.get_constant_list(type):
			theme.set_constant(constant, type, Game.original_theme.get_constant(constant, type) * scale_factor)
			
			
	for type in theme.get_stylebox_types():
		for n in theme.get_stylebox_list(type):
			var stylemap = theme.get_stylebox(n, type)
			var og_stylemap = Game.original_theme.get_stylebox(n, type)
			stylemap.content_margin_bottom = scale_margin(og_stylemap.content_margin_bottom, scale_factor)
			stylemap.content_margin_top = scale_margin(og_stylemap.content_margin_top, scale_factor)
			stylemap.content_margin_left = scale_margin(og_stylemap.content_margin_left, scale_factor)
			stylemap.content_margin_right = scale_margin(og_stylemap.content_margin_right, scale_factor)
	update()

func set_turns(turns):
	$"%TurnsLabel".text = str(Game.turns)
	var progress = lerp($"%TurnsProgress".min_value, $"%TurnsProgress".max_value, Game.turns / Game.max_turns)
	$"%TurnsProgress/Tween".interpolate_property($"%TurnsProgress", "value", $"%TurnsProgress".value, progress, 0.5)
	$"%TurnsProgress/Tween".start()
	
func get_bottom_edge():
	return $"%BottomEdge"

func get_left_edge():
	return $"%LeftEdge"
	
func get_top_edge():
	return $"%TopEdge"
	
func get_right_bar():
	return $"%RightBar"

func _on_OpenShopButton_pressed():
	Game.emit_signal("change_scene", "res://shop.tscn")
