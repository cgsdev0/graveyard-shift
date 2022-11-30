extends Control

func _ready():
	get_tree().get_root().connect("size_changed", self, "on_resize")
	Game.connect("prep_new_turn", self, "start_new_turn")
	call_deferred("on_resize")
	if !Game.original_theme:
		Game.original_theme = theme.duplicate(true)
	
	set_turns(Game.turns)
	
func get_friend():
	return $"%Friend"

func get_friend_rect():
	return Rect2($"%RightBar".rect_global_position + Vector2(0, $"%RightBar".rect_size.y * 0.5), $"%RightBar".rect_size)
	
func start_new_turn():
	Game.turns -= 1
	set_turns(Game.turns)
	if Game.turns == 0:
		Game.emit_signal("you_win")
		yield(Game, "daylight_animation_done")
		$YouWin/AnimationPlayer.play("victory")
	else:
		Game.emit_signal("deal_new_turn")
	
func set_hover_text(text):
	if text:
		$"%HoverDescription".text = text
		$"%HoverDescription".visible = true
		$"%NoHover".visible = false
	else:
		$"%HoverDescription".visible = false
		$"%NoHover".visible = true
		
func scale_margin(original_margin, scale_factor):
	if original_margin == -1:
		return -1
	return original_margin * scale_factor

var min_sizes = {}
func scale_children(node, scale_factor):
	for child in node.get_children():
		if child == $Tooltip:
			continue
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
	var scale_factor = pow(min(v.x / 800.0, v.y / 450.0), 0.8)
	
	for type in theme.get_font_types():
		for font in theme.get_font_list(type):
			var f = theme.get_font(font, type)
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

func _process(delta):
	var s = get_viewport().get_mouse_position() / get_viewport().size
	$"%Face3D".set_rot(clamp(s.x, 0, 1), clamp(s.y, 0, 1))
	
func set_turns(turns):
	$"%TurnsLabel".text = str(Game.turns)
	
func get_bottom_edge():
	return $"%BottomEdge"

func get_left_edge():
	return $"%LeftEdge"
	
func get_top_edge():
	return $"%TopEdge"
	
func get_right_bar():
	return $"%RightBar"

func compute_tooltip_size():
	var current_y = 0.0
	var computed_width = 0.0
	var biggest_height = 0.0
	var all_widths = []
	var total_height = 0.0
	for child in $Tooltip.get_children():
		if !child.visible:
			continue
		if child.rect_position.y != current_y:
			all_widths.push_back(computed_width)
			current_y = child.rect_position.y
			computed_width = 0.0
			if total_height > 0.0 && biggest_height > 0.0:
				# spacing
				total_height += 20.0
			total_height += biggest_height
			biggest_height = 0.0
		elif computed_width > 0.0:
			# spacing between containers
			computed_width += 20.0
		computed_width += child.rect_size.x
		biggest_height = max(biggest_height, child.rect_size.y)
	all_widths.push_back(computed_width)
	if total_height > 0.0 && biggest_height > 0.0:
		# spacing
		total_height += 20.0
	total_height += biggest_height
	return Vector2(all_widths.max(), total_height)
	
var TokenTooltip = preload("res://ui/token_tooltip.tscn")
var tooltip_pos = null
func show_tooltip(position, data):
	if position == tooltip_pos:
		return
	hide_tooltip()
	tooltip_pos = position
	if data.tile.type == Game.TileType.EMPTY || data.tile.type == Game.TileType.PIT:
		$Tooltip/TileTooltip.visible = false
	else:
		$Tooltip/TileTooltip.visible = true
		$Tooltip/TileTooltip/VBoxContainer/Label.text = data.tile.get_title()
		for i in range(data.tile.wall_flags.size()):
			var flag = data.tile.wall_flags[i] if data.tile.type != Game.TileType.BRIDGE else 0
			$Tooltip/TileTooltip/VBoxContainer/Health.get_child(i * 2).visible = flag > 0
			$Tooltip/TileTooltip/VBoxContainer/Health.get_child(i * 2 + 1).visible = flag > 0
			
			if flag > 0:
				var j = 1
				for child in $Tooltip/TileTooltip/VBoxContainer/Health.get_child(i * 2 + 1).get_children():
					child.visible = j <= flag
					j += 1
					
	for token in data.tokens:
		var tt = TokenTooltip.instance()
		tt.describe(token)
		$Tooltip.add_child(tt)
		
	$Tooltip.show()
	yield(get_tree().create_timer(0.0), "timeout")
	var size = compute_tooltip_size()
	$Tooltip.rect_global_position = Vector2(
		clamp(position.x - ($RightBar.rect_size.x  + size.x / 2), 0, get_viewport().size.x - size.x),
		clamp(position.y - size.y, 0, get_viewport().size.y - size.y))

func hide_tooltip():
	tooltip_pos = null
	$Tooltip.hide()
	for i in range(1, $Tooltip.get_child_count()):
		var child = $Tooltip.get_child(i)
		$Tooltip.remove_child(child)
		child.queue_free()
	
func _on_OpenShopButton_pressed():
	Game.money += 15 + 5 * (Game.level / 2)
	if Game.earned_treasure:
		Game.earned_treasure = false
		var prize = ShopDeck.deal_treasure()
		Deck.pending_treasure_card = prize
	Game.level += 1
	Game.emit_signal("reset")
	Game.emit_signal("change_scene", "res://shop.tscn")
