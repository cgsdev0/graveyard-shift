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

func _ready():
	initial_cards_position = $Cards.global_translation
	board = Game.get_board()
	$Mouse.dist_from_camera = dist_from_camera - hold_dist
	Game.connect("start_drag", self, "start_drag")
	Game.connect("start_hover", self, "start_hover")
	Game.connect("end_hover", self, "end_hover")
	Game.connect("start_new_turn", self, "on_start_new_turn")
	get_tree().get_root().connect("size_changed", self, "on_resize")
	call_deferred("on_resize")
	yield(get_tree().create_timer(0.5), "timeout")
	on_start_new_turn()
	

func on_resize():
	call_deferred("adjust_hand")
	
func on_start_new_turn():
	cards_up = true
	while deal_card():
		yield(get_tree().create_timer(0.2), "timeout")
	
func end_hover(card):
	if card.placed:
		return
	if dragging == card:
		return
	if hover == card:
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
	if drag == null:
		if self.dragging != null:
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
	hover = card
	var hand_pos = get_pos_in_hand(card.get_index(), $Cards.get_child_count())
	var tween = card.get_node("Tween") as Tween
	tween.interpolate_property(card, "global_translation", 
		card.global_translation, 
		project_to_3d(hand_pos + Vector2(0.0, -50.0), 50),
		tween_time, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()

func set_snap_tile(tile):
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
		dragging.set_layer_mask(1)
		dragging.show_error(dragging.ac > Game.actions)
		tween.interpolate_property(dragging, "global_translation", 
			dragging.global_translation, 
			snap_tile.global_translation + snap_tile.size / 2 + Vector3(0, 0.1, 0),
			tween_time, Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween.interpolate_property(dragging, "global_rotation", 
			dragging.global_rotation, 
			snap_tile.global_transform.basis.rotated(Vector3.RIGHT, -PI / 2).get_euler(),
			tween_time, Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween.start()
		
func get_pos_in_hand(i, total):
	var v = get_viewport().size
	var y = v.y - (50 if cards_up else -15)
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
			
func _deal_card(slot_type):
	var new_card = Deck.deal(slot_type)
	if new_card == null:
		return
	var card = preload("res://hand/draggable_card.tscn").instance()
	card.rotation = get_viewport().get_camera().rotation
	card.slot_type = slot_type
	card.become(new_card)
	$Cards.add_child(card)
	adjust_hand()

func deal_card():
	var counts = {}
	for key in Game.SlotType.values():
		counts[key] = 0
		
	for c in $Cards.get_children():
		counts[c.slot_type] += 1
	for key in counts.keys():
		if counts[key] < Deck.desired_count(key):
			_deal_card(key)
			return true
	return false
	
func move_cards_vertically():
	if !is_mouse_in_card_area() && cards_up && (hover == null || dragging):
		cards_up = false
		adjust_hand() 
	if is_mouse_in_card_area() && !cards_up && board.has_actions():
		cards_up = true
		adjust_hand()
	
func _process(delta):
	# if Input.is_action_just_pressed("ui_accept"):
	# 	deal_card()
	move_cards_vertically()
	if dragging:
		var tween = dragging.get_node("Tween") as Tween
		if !Input.is_mouse_button_pressed(1):
			if snap_tile && Game.actions >= dragging.ac:
				dragging.placed = true
				# place the tile
				board.place_card_on_tile(dragging, snap_tile.get_index())
				# TODO: maybe a cool transition effect here?
				if dragging.should_stay_on_board():
					dragging.placed_at = snap_tile.get_index()
					dragging.add_to_group("placed_tiles")
					dragging.set_owner(self)
					dragging.get_node("Tween").resume_all()
				else:
					dragging.queue_free()
				hover = null
				dragging = null
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

func _physics_process(delta):
	if dragging:
		var space = get_world().direct_space_state
		var mouse = get_mouse_position()
		var from = get_viewport().get_camera().project_ray_origin(mouse)
		var to = from + get_viewport().get_camera().project_ray_normal(mouse) * 600
		var result = space.intersect_ray(from, to, [], 0b10, false, true)
		if result.has("collider"):
			if dragging.type == Game.TileType.BRIDGE:
				if result.collider.type == Game.TileType.PIT:
					if snap_tile != result.collider:
						set_snap_tile(result.collider)
			else:
				if result.collider.type == Game.TileType.EMPTY:
					for token in get_tree().get_nodes_in_group("tokens"):
						if token.get_id() == result.collider.get_index():
							return
					if snap_tile != result.collider:
						set_snap_tile(result.collider)
		elif snap_tile != null:
			set_snap_tile(null)
		
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
