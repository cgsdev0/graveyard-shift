class_name Card
extends Button

enum SlotType {
	WALL,
	ITEM
}

export(SlotType) var slot_type
export(Game.TileType) var type
var wall_flags = 0b1100

func become(card):
	if card == null:
		type = Game.TileType.EMPTY
		return
	type = card.type
	if type == Game.TileType.WALL:
		wall_flags = card.wall_flags

func deal():
	match slot_type:
		SlotType.WALL:
			become(Deck.deal_wall())
		SlotType.ITEM:
			become(Deck.deal_item())
			
var board

func _ready():
	board = Game.get_board()
	self.text = Game.TileType.keys()[type]
	self.connect("pressed", self, "on_press")
	Game.connect("start_new_turn", self, "start_new_turn")
	deal()
	pass

func check_wall_bit(flag):
	return wall_flags & (1 << flag)
	
func start_new_turn():
	if type == Game.TileType.EMPTY:
		deal()
		
func _process(delta):
	self.text = Game.TileType.keys()[type]
	if type == Game.TileType.WALL:
		if check_wall_bit(Game.Direction.NORTH):
			self.text += " NORTH"
		if check_wall_bit(Game.Direction.SOUTH):
			self.text += " SOUTH"
		if check_wall_bit(Game.Direction.EAST):
			self.text += " EAST"
		if check_wall_bit(Game.Direction.WEST):
			self.text += " WEST"
		
	self.visible = type != Game.TileType.EMPTY
	self.disabled = board.actions == 0

func on_press():
	if type == Game.TileType.EMPTY:
		return
	Game.emit_signal("select_card", self)
	pass
