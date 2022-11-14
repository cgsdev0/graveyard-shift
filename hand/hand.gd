extends Spatial


var mouse_cast
var dragging = null
var hover = null

var snap_tile = null
var dist_from_camera = 15.0
export var tween_time = 0.2
export var hold_dist = 0.5

var board

func _ready():
	board = Game.get_board()
	$Mouse.dist_from_camera = dist_from_camera - hold_dist
	Game.connect("start_drag", self, "start_drag")
	Game.connect("start_hover", self, "start_hover")
	Game.connect("end_hover", self, "end_hover")
	Game.connect("start_new_turn", self, "on_start_new_turn")
	get_tree().get_root().connect("size_changed", self, "on_resize")
	yield(get_tree().create_timer(0.5), "timeout")
	on_start_new_turn()
	

func on_resize():
	adjust_hand()
	
func on_start_new_turn():
	while deal_card():
		yield(get_tree().create_timer(0.2), "timeout")
	
func end_hover(card):
	if card.placed:
		return
	if dragging:
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
	
func start_hover(card):
	if card.placed:
		return
	if dragging:
		return
	if hover:
		end_hover(card)
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
	var mouse = get_viewport().get_mouse_position()
	var hand_pos = Vector2(get_viewport().size.x / 2, get_viewport().size.y / 5 * 4)
	var tween = dragging.get_node("Tween") as Tween
	if tile == null:
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
	var y = v.y - 50
	# TODO: be more thoughtful here
	var left_offset = 100
	if total == 1:
		return Vector2(v.x / 2 - left_offset, y)
	else:
		var ratio = float(i) / (total - 1.0) - 0.5
		var hand_width = lerp(v.x / 10, v.x / 5 * 4, ease((total - 1.0) / 10.0, 0.5))
		return Vector2(v.x / 2  - left_offset + ratio * hand_width, y)
		
func project_to_3d(v: Vector2, f: float) -> Vector3:
	return get_viewport().get_camera().project_position(v, dist_from_camera - float(f) / 100.0)
	
func adjust_hand():
	var cards = $Cards.get_child_count()
	for c in $Cards.get_children():
		var tween = c.get_node("Tween") as Tween
		tween.interpolate_property(c, "global_translation", 
			c.global_translation, 
			project_to_3d(get_pos_in_hand(c.get_index(), cards), c.get_index()),
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
	
func _process(delta):
	# if Input.is_action_just_pressed("ui_accept"):
	# 	deal_card()
	if dragging:
		var tween = dragging.get_node("Tween") as Tween
		if !Input.is_mouse_button_pressed(1):
			if snap_tile:
				dragging.placed = true
				# place the tile
				board.place_card_on_tile(dragging, snap_tile.get_index())
				$Cards.remove_child(dragging)
				# TODO: maybe a cool transition effect here?
				if dragging.should_stay_on_board():
					dragging.placed_at = snap_tile.get_index()
					dragging.add_to_group("placed_tiles")
					self.add_child(dragging)
					dragging.set_owner(self)
					dragging.get_node("Tween").resume_all()
				else:
					dragging.queue_free()
				adjust_hand()
				dragging = null
				return
			var hand_pos = get_pos_in_hand(dragging.get_index(), $Cards.get_child_count())
			tween.interpolate_property(dragging, "global_translation", 
				dragging.global_translation, 
				project_to_3d(hand_pos, dragging.get_index()),
				tween_time, Tween.TRANS_QUAD, Tween.EASE_OUT)
			tween.interpolate_property(dragging, "global_rotation", 
				dragging.global_rotation, 
				get_viewport().get_camera().global_rotation,
				tween_time, Tween.TRANS_QUAD, Tween.EASE_OUT)
			tween.start()
			dragging = null
			return
		var mouse = get_viewport().get_mouse_position()
		if snap_tile == null:
			if tween.is_active():
				pass
			else:
				dragging.rotation = get_viewport().get_camera().rotation
				dragging.global_translation = get_viewport().get_camera().project_position(mouse, dist_from_camera - hold_dist)

func _physics_process(delta):
	if dragging:
		var space = get_world().direct_space_state
		var mouse = get_viewport().get_mouse_position()
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
		
func start_drag(card):
	if card.placed:
		return
	if dragging == null:
		dragging = card
