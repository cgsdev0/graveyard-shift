extends Area

export(Game.SlotType) var slot_type
export(Game.TileType) var type
var ac = 1
var wall_flags = [0, 0, 0, 0]

var disabled = false
var placed = false
var placed_at

var old_index

var card 

func show_error(show):
	$Tile.visible = !show
	$NoPlace.visible = show
	
func placement_animation():
	match type:
		Game.TileType.WALL, Game.TileType.BRIDGE:
			$Tile.play_animation("scale_up_walls")
		_:
			$Tile.play_animation("fade_out_header")

func recompute_wall_decals():
	var bits = 0
	for i in range(wall_flags.size()):
		if wall_flags[i]:
			bits |= 1 << i
	$Tile.decal_bits = bits
	
func become(card):
	self.card = card
	if card == null:
		type = Game.TileType.EMPTY
		return
	$Tile.set_text(str(card.ac), Game.title_card(card))
	$Tile.header_tint = Deck.card_color(card)
	ac = card.ac
	type = card.type
	if Game.is_wall(type):
		wall_flags = card.wall_flags
		match card.type:
			Game.TileType.WALL, Game.TileType.SECRET_DOOR:
				$Tile.enable_hearts(card.wall_flags.max())
		recompute_wall_decals()

			
var board

func should_stay_on_board():
	match type:
		Game.TileType.MONEY_TREE, Game.TileType.LURE, Game.TileType.COURAGE:
			return false
	return true
	
func _ready():
	board = Game.get_board()
	$Label3D.text = Game.TileType.keys()[type]

func check_wall_bit(flag):
	return wall_flags[flag]
	
func _process(delta):
	$Label3D.text = Game.TileType.keys()[type]
	var is_bridge = int(type == Game.TileType.BRIDGE)
	if Game.is_wall(type):
		if is_bridge ^ int(bool(check_wall_bit(Game.Direction.NORTH))):
			$Label3D.text += " NORTH"
		if is_bridge ^ int(bool(check_wall_bit(Game.Direction.SOUTH))):
			$Label3D.text += " SOUTH"
		if is_bridge ^ int(bool(check_wall_bit(Game.Direction.EAST))):
			$Label3D.text += " EAST"
		if is_bridge ^ int(bool(check_wall_bit(Game.Direction.WEST))):
			$Label3D.text += " WEST"
		
	self.disabled = Game.actions == 0

func set_translation(glob):
	global_translation = glob
	
func set_layer_mask(layer):
	$Tile.get_node("Plane").set_layer_mask(layer)
	$Label3D.set_layer_mask(layer)
	
func _on_Area_input_event(camera, event, position, normal, shape_idx):
	if disabled:
		return
	if event is InputEventMouseButton && event.button_index == 1:
		if event.pressed:
			var offset = position - global_translation
			Game.emit_signal("start_drag", self, offset)


func _on_Area_mouse_entered():
	if disabled:
		return
	Game.emit_signal("start_hover", self)


func _on_Area_mouse_exited():
	if disabled:
		return
	Game.emit_signal("end_hover", self)
