extends Node

var starting_deck = {
	Game.SlotType.WALL: {
		"cards": [
		],
		"desired_count": 0,
	 },
	 Game.SlotType.ITEM: {
		"cards": [
			#                                            N  S  E  W
			{ "type": Game.TileType.WALL, "wall_flags": [1, 0, 0, 0] },
			{ "type": Game.TileType.WALL, "wall_flags": [0, 1, 0, 0] },
			{ "type": Game.TileType.WALL, "wall_flags": [0, 0, 1, 0] },
			{ "type": Game.TileType.WALL, "wall_flags": [0, 0, 0, 1] },
			# definitely not base deck cards:
			#{ "type": Game.TileType.BRIDGE, "wall_flags": [1000, 1000, 0, 0] },
			#{ "type": Game.TileType.SECRET_DOOR, "wall_flags": [0, 0, 0, 100] },
			{ "type": Game.TileType.MONEY_TREE },
			{ "type": Game.TileType.MONEY_TREE },
			{ "type": Game.TileType.LURE },
			{ "type": Game.TileType.TRAP },
		],
		"desired_count": 4,
	}
}

var deck = starting_deck.duplicate(true)

func _ready():
	Game.connect("reset", self, "on_reset")
	randomize()
	on_reset()

func on_reset():
	deck = starting_deck.duplicate(true)
	for key in deck.keys():
		deck[key].cards.shuffle()
		pass
	
func desired_count(slot_type):
	return deck[slot_type].desired_count
	
func deal(slot_type):
	return deck[slot_type].cards.pop_back()
