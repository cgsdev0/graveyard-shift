extends Area

export(Game.SlotType) var slot_type
export(Game.TileType) var type
var wall_flags = [0, 0, 0, 0]

var disabled = false
var placed = false
var placed_at

func become(card):
	if card == null:
		type = Game.TileType.EMPTY
		return
	type = card.type
	if Game.is_wall(type):
		wall_flags = card.wall_flags

			
var board

func should_stay_on_board():
	match type:
		Game.TileType.MONEY_TREE, Game.TileType.LURE:
			return false
	return true
	
func _ready():
	board = Game.get_board()
	$Label3D.text = Game.TileType.keys()[type]
	match slot_type:
		Game.SlotType.ITEM:
			pass
		Game.SlotType.WALL:
			$Tile.material.albedo_color = Color.rebeccapurple
	pass

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
		
	self.disabled = board.actions == 0

func set_translation(glob):
	global_translation = glob
	
func set_layer_mask(layer):
	$Tile.set_layer_mask(layer)
	$Label3D.set_layer_mask(layer)
	
func _on_Area_input_event(camera, event, position, normal, shape_idx):
	if disabled:
		return
	if event is InputEventMouseButton && event.button_index == 1:
		if event.pressed:
			Game.emit_signal("start_drag", self)


func _on_Area_mouse_entered():
	if disabled:
		return
	Game.emit_signal("start_hover", self)


func _on_Area_mouse_exited():
	if disabled:
		return
	Game.emit_signal("end_hover", self)
