class_name ShopCard3D
extends Spatial

var follow_node
var card
var wall_flags = [0,0,0,0]

var textures = {
	Game.TileType.MONEY_TREE: preload("res://textures/cards/money_tree.png"),
	Game.TileType.LURE: preload("res://textures/cards/lure.png"),
	Game.TileType.TRAP: preload("res://textures/cards/trap.png"),
}

func recompute_wall_decals():
	var bits = 0
	if Game.is_wall(card.type):
		#if card.type == Game.TileType.WALL:
		$Card.override_decal(null)
		for i in range(wall_flags.size()):
			if wall_flags[i]:
				bits |= 1 << i
	elif textures.has(card.type):
		bits = 1
		$Card.override_decal(textures[card.type])
	$Card.decal_bits = bits
	
func become(card):
	self.card = card
	if card == null:
		return
	$Card.set_text(str(card.ac), Game.title_card(card))
	$Card.header_tint = Deck.card_color(card)
	$Card.enable_hearts(0)
	if Game.is_wall(card.type):
		wall_flags = card.wall_flags
		match card.type:
			Game.TileType.WALL, Game.TileType.SECRET_DOOR:
				$Card.enable_hearts(card.wall_flags.max())
	recompute_wall_decals()
		

var tween: Tween
var hover_time: float = 0.0

func _ready():
	tween = Tween.new()
	add_child(tween)
	pass

func _process(delta):
	do_process(delta)
	
func do_process(delta):
	var cam = get_parent() as Camera
	global_translation = cam.project_position(follow_node.rect_global_position + follow_node.rect_size / 2.0, 20.0)
	var pos1 = cam.unproject_position(global_translation)
	var pos2 = cam.unproject_position(global_translation + Vector3(0, 2.2, 2.2))
	var bb = (pos1 - pos2) * 2.0
	var bb_size = max(abs(bb.x), abs(bb.y))
	var parent_bb_size = min(follow_node.rect_size.x, follow_node.rect_size.y)
	var sf = parent_bb_size / bb_size
	
	var scaled_rect = Rect2(pos1 - Vector2(bb_size, bb_size) * sf / 2.0, Vector2(bb_size, bb_size) * sf)
	# get_parent().get_parent().get_parent().get_node("Node2D").rects.push_back(scaled_rect)
	
	if scaled_rect.has_point(get_viewport().get_mouse_position()):
		tween.set_active(false)
		hover_time += delta
		global_rotation = Vector3.ZERO
		var target = clamp((pos1.x - get_viewport().get_mouse_position().x) / scaled_rect.size.x, -1, 1)
		rotate(Vector3(0, 0.8, 0.2).normalized(), lerp(0, target, ease(clamp(hover_time * 5.0, 0, 1), 0.5)))
	elif hover_time > 0.0:
		hover_time = 0.0
		tween.interpolate_property(self, "global_rotation", global_rotation, Vector3.ZERO, 0.4, Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween.start()
		
	scale = Vector3(sf, sf, sf)
	

