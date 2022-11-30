extends Spatial


var mouse_cast
var dragging = null
var hover = null

var snap_tile = null
var dist_from_camera = 15.0
export var tween_time = 0.2
export var hold_dist = 0.5

var board
var offset

var cards_up = true
var initial_cards_position

var DraggableCard = preload("res://hand/draggable_card.tscn")
var ForesightCard = preload("res://foresight_card.tscn")

func _ready():
	initial_cards_position = $Cards.global_translation
	board = Game.get_board()
	$Mouse.dist_from_camera = dist_from_camera - hold_dist
	Game.connect("start_drag", self, "start_drag")
	Game.connect("start_hover", self, "start_hover")
	Game.connect("end_hover", self, "end_hover")
	Game.connect("deal_new_turn", self, "on_deal_new_turn")
	get_tree().get_root().connect("size_changed", self, "on_resize")
	call_deferred("on_resize")
	yield(get_tree().create_timer(0.5), "timeout")
	

func on_resize():
	call_deferred("adjust_hand")
	
func on_deal_new_turn():
	cards_up = true
	while deal_card():
		yield(get_tree().create_timer(0.2), "timeout")
	Game.emit_signal("start_new_turn")
	
func end_hover(card):
	if card.placed:
		return
	if dragging == card:
		return
	if hover == card:
		$"%UI".set_hover_text(null)
		var hand_pos = get_pos_in_hand(hover.get_index(), $Cards.get_child_count())
		var tween = hover.get_node("Tween") as Tween
		tween.interpolate_property(hover, "global_translation", 
			hover.global_translation, 
			project_to_3d(hand_pos, hover.get_index()),
			tween_time, Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween.start()
		hover = null
		
func get_mouse_position():
	return get_viewport().get_mouse_position() - Vector2(0, $"%GameView".margin_top)
	
func is_mouse_in_card_area():
	var mouse = get_mouse_position()
	return mouse.y > get_viewport().size.y - $"%UI".get_bottom_edge().rect_size.y * 1.2
	
func set_dragging(drag):
	compute_valid_tiles(drag)
	if drag == null:
		if self.dragging != null:
			$SubtleSound.play()
			disable_tile_highlights()
			recolor_highlights_for_lure(null)
			dragging.show_error(false)
			var mouse = get_mouse_position()
			if is_mouse_in_card_area():
				var proj = get_viewport().get_camera().project_position(mouse, dist_from_camera - hold_dist)
				var ind = -1
				for i in $Cards.get_child_count():
					if $Cards.get_child(i).global_translation.x < proj.x:
						ind = i
					else:
						break
				if ind + 1 == $Cards.get_child_count():
					dragging.old_index = -1
				else:
					dragging.old_index = ind + 1
			self.remove_child(dragging)
			$Cards.add_child(dragging)
			if dragging.old_index >= 0:
				$Cards.move_child(dragging, dragging.old_index)
			call_deferred("adjust_hand")
	else:
		if !Game.is_turn:
			return
		if Game.block_interaction:
			return
		$SubtleSound.play()
		highlight_valid_tiles()
		if drag.type == Game.TileType.LURE:
			recolor_highlights_for_lure(drag.card.range)
		hover = null
		drag.old_index = drag.get_index()
		$Cards.remove_child(drag)
		self.add_child(drag)
		call_deferred("adjust_hand")
	self.dragging = drag
	
func start_hover(card):
	if card.placed:
		return
	if hover && hover != card:
		end_hover(hover)
	if dragging:
		return
	if !Game.is_turn:
		return
	if Game.block_interaction:
		return
	hover = card
	$"%UI".set_hover_text(Game.describe_card(card.card))
	$SubtleSound.play()
	var hand_pos = get_pos_in_hand(card.get_index(), $Cards.get_child_count())
	var tween = card.get_node("Tween") as Tween
	tween.interpolate_property(card, "global_translation", 
		card.global_translation, 
		project_to_3d(hand_pos + Vector2(0.0, -50.0), 50),
		tween_time, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()

func set_snap_tile(tile):
	if self.snap_tile == tile:
		return
	if tile != null && self.snap_tile == null:
		$PickupSound.play()
	elif tile != null && self.snap_tile != null:
		$SlideSound.play()
	elif tile == null && self.snap_tile != null:
		$PickupSound.play()
	self.snap_tile = tile
	var mouse = get_mouse_position()
	var hand_pos = Vector2(get_viewport().size.x / 2, get_viewport().size.y / 5 * 4)
	var tween = dragging.get_node("Tween") as Tween
	if tile == null:
		dragging.set_layer_mask(2)
		dragging.show_error(false)
		tween.follow_property(dragging, "global_translation", 
			dragging.global_translation, 
			$Mouse,
			"global_translation",
			tween_time, Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween.interpolate_property(dragging, "global_rotation", 
			dragging.global_rotation, 
			get_viewport().get_camera().global_rotation,
			tween_time, Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween.start()
	else:
#		if dragging.type == Game.TileType.LURE:
#			recolor_highlights_for_lure(dragging.card.range)
		dragging.set_layer_mask(1)
		dragging.show_error(dragging.card.ac > Game.actions)
		tween.interpolate_property(dragging, "global_translation", 
			dragging.global_translation, 
			snap_tile.get_center(),
			tween_time, Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween.interpolate_property(dragging, "global_rotation", 
			dragging.global_rotation, 
			snap_tile.global_transform.basis.rotated(Vector3.RIGHT, -PI / 2).get_euler(),
			tween_time, Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween.start()
		
func get_pos_in_hand(i, total):
	var v = get_viewport().size
	var y_scale = v.y / 450.0
	var y = v.y - (50 if cards_up else -15) * y_scale
	var v_width = v.x - $"%UI".get_right_bar().rect_size.x
	if total == 1:
		return Vector2(v.x / 2, y)
	else:
		var ratio = float(i) / (total - 1.0) - 0.5
		var hand_width = lerp(v_width / 10, v_width / 5 * 4, ease((total - 1.0) / 10.0, 0.5))
		return Vector2(v.x / 2 + ratio * hand_width, y)
		
func project_to_3d(v: Vector2, f: float) -> Vector3:
	return get_viewport().get_camera().project_position(v, dist_from_camera - float(f) / 100.0)
	
func adjust_hand():
	var cards = $Cards.get_child_count()
	for c in $Cards.get_children():
		c.set_layer_mask(2)
		var tween = c.get_node("Tween") as Tween
		tween.interpolate_property(c, "global_translation", 
			c.global_translation, 
			project_to_3d(get_pos_in_hand(c.get_index(), cards), c.get_index()),
			tween_time, Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween.interpolate_property(c, "global_rotation", 
			c.global_rotation, 
			get_viewport().get_camera().global_rotation,
			tween_time, Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween.start()
			
func deal_card():
	if $Cards.get_child_count() >= Deck.desired_count():
		return false
	var new_card = Deck.deal()
	if new_card == null:
		return false
	$DealSound.play()
	var card = DraggableCard.instance()
	card.rotation = get_viewport().get_camera().rotation
	card.become(new_card)
	$Cards.add_child(card)
	adjust_hand()
	return true
	
func move_cards_vertically():
	if (!is_mouse_in_card_area() && cards_up && (hover == null || dragging)) || (!Game.is_turn && cards_up):
		cards_up = false
		adjust_hand() 
	if is_mouse_in_card_area() && !cards_up && board.has_actions() && Game.is_turn:
		cards_up = true
		adjust_hand()
	
func do_fresh_start():
	Game.block_interaction = true
	var i = 0
	for child in $Cards.get_children():
		child.placed = true
		Deck.return_card(child.card)
		var t = child.global_transform
		$Cards.remove_child(child)
		get_parent().get_parent().add_child(child)
		child.set_owner(get_parent().get_parent())
		child.global_transform = t
		child.discard_animation(i)
		i += 1
	if i > 0:
		yield(get_tree().create_timer(1.5), "timeout")
	while deal_card():
		yield(get_tree().create_timer(0.2), "timeout")
	Game.block_interaction = false
	
func do_foresight():
	if Deck.empty():
		return
	Game.emit_signal("foresight")
	Game.block_interaction = true
	for i in [2, 1, 0]:
		var card = Deck.deal()
		if !card:
			break
		var f_card = ForesightCard.instance()
		f_card.become(card)
		f_card.index = i
		get_parent().get_parent().add_child(f_card)
		yield(get_tree().create_timer(0.2), "timeout")
func _process(delta):
	# if Input.is_action_just_pressed("ui_accept"):
	# 	deal_card()
	move_cards_vertically()
	if dragging:
		var tween = dragging.get_node("Tween") as Tween
		if !Input.is_mouse_button_pressed(1):
			if (snapped_friend || snap_tile) && Game.actions >= dragging.card.ac:

				disable_tile_highlights()
				recolor_highlights_for_lure(null)
				dragging.placed = true
				
				Game.actions -= dragging.card.ac
				
				if snapped_friend:
					match dragging.card.type:
						Game.TileType.ACTION_SURGE:
							Game.actions += dragging.card.actions
						Game.TileType.FRESH_START:
							do_fresh_start()
						Game.TileType.FORESIGHT:
							do_foresight()
				# place the tile
				if !snapped_friend:
					board.place_card_on_tile(dragging, snap_tile.get_index())
					dragging.placed_at = snap_tile.get_index()
					dragging.placed_on = snap_tile
					dragging.add_to_group("placed_tiles")
				
				var t = dragging.global_transform
				remove_child(dragging)
				get_parent().get_parent().add_child(dragging)
				dragging.set_owner(get_parent().get_parent())
				dragging.global_transform = t
				if snap_tile:
					dragging.placement_animation(snap_tile.type)
				else:
					dragging.placement_animation()
				
				if !snapped_friend:
					snap_tile.stacks += 1
					dragging.get_node("Tween").resume_all()

				hover = null
				dragging = null
				$"%UI".get_friend().unbump()
				snapped_friend = false
				if board.has_actions():
					cards_up = true
				adjust_hand()
				return
			set_dragging(null)
			return
		var mouse = get_mouse_position()
		if snap_tile == null:
			if tween.is_active():
				pass
			else:
				dragging.rotation = get_viewport().get_camera().rotation
				dragging.global_translation = get_viewport().get_camera().project_position(mouse, dist_from_camera - hold_dist) - offset

var snapped_friend = false
var showing_tooltip_for = null
func _physics_process(delta):
	if !Game.is_turn:
		if showing_tooltip_for:
			showing_tooltip_for = null
			$"%UI".hide_tooltip()
		return
	var space = get_world().direct_space_state
	var mouse = get_mouse_position()
	var from = get_viewport().get_camera().project_ray_origin(mouse)
	var to = from + get_viewport().get_camera().project_ray_normal(mouse) * 600
	var result = space.intersect_ray(from, to, [], 0b10, false, true)
	if dragging:
		var friend = $"%UI".get_friend()
		var friend_rect = $"%UI".get_friend_rect()
		if friend_is_valid && friend_rect.has_point($"%UI".get_viewport().get_mouse_position()):
			friend.bump()
			snapped_friend = true
			return
		else:
			friend.unbump()
			snapped_friend = false
		if result.has("collider"):
			showing_tooltip_for = result.collider
			if result.collider in valid_tiles:
					if snap_tile != result.collider:
						set_snap_tile(result.collider)
		elif snap_tile != null:
			showing_tooltip_for = null
			set_snap_tile(null)
	else:
		# consider a tooltip
		if result.has("collider"):
			if showing_tooltip_for == result.collider:
				return
			showing_tooltip_for = result.collider
			var tokens = []
			for token in get_tree().get_nodes_in_group("tokens"):
				if token.get_id() == result.collider.get_index():
					tokens.push_back(token)
			$"%UI".show_tooltip(
				get_viewport().get_camera().unproject_position(result.collider.get_center() + Vector3(0, 0.55, 0)), 
				{ "tile": result.collider, "tokens": tokens })
		else:
			showing_tooltip_for = null
			$"%UI".hide_tooltip()
var valid_tiles = []
var friend_is_valid = false
func compute_valid_tiles(card):
	valid_tiles = []
	friend_is_valid = false
	if card == null:
		return
	for tile in board.get_children():
		if card.type == Game.TileType.BRIDGE:
			if tile.type == Game.TileType.PIT:
				valid_tiles.push_back(tile)
		elif card.type == Game.TileType.COURAGE:
			for token in get_tree().get_nodes_in_group("adventurers"):
				if token.get_id() == tile.get_index():
					valid_tiles.push_back(tile)
		elif card.type == Game.TileType.ACTION_SURGE:
			friend_is_valid = true
			break
		elif card.type == Game.TileType.FORESIGHT:
			friend_is_valid = true
			break
		elif card.type == Game.TileType.FRESH_START:
			friend_is_valid = true
			break
		elif card.type == Game.TileType.GUST:
			for token in get_tree().get_nodes_in_group("pathfinders"):
				if token.get_id() == tile.get_index():
					var next_id = board.compute_tile_id(token.get_id(), Game.gust_direction(card.card.direction))
					if board.is_on_board(next_id):
						valid_tiles.push_back(tile)
			
		else:
			if tile.type == Game.TileType.EMPTY:
				var should_add = true
				for token in get_tree().get_nodes_in_group("tokens"):
					if token.get_id() == tile.get_index():
						should_add = false
				if should_add:
					valid_tiles.push_back(tile)

func recolor_highlights_for_lure(lure_range):
	if typeof(lure_range) != TYPE_INT:
		for tile in board.get_children():
			tile.set_selection_glow_color(null)
		return
	for monster in get_tree().get_nodes_in_group("monsters"):
		for tile in valid_tiles:
			if monster.manhattan_distance(tile.get_index(), monster.get_id()) <= lure_range:
				tile.set_selection_glow_color(Color.yellow)
		
func highlight_valid_tiles():
	if friend_is_valid:
		Game.emit_signal("highlight_friend", true)
	for tile in valid_tiles:
		tile.set_selection_glow(true)
		
func disable_tile_highlights():
	Game.emit_signal("highlight_friend", false)
	for tile in board.get_children():
		tile.set_selection_glow(false)
		
func start_drag(card, pos):
	if card.placed:
		return
	if dragging == null:
		if hover:
			set_dragging(hover)
			offset = pos
		else:
			set_dragging(card)
			offset = pos
