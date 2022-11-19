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
			{ "type": Game.TileType.WALL, "wall_flags": [1, 0, 0, 0], "ac": 1 },
			{ "type": Game.TileType.WALL, "wall_flags": [1, 0, 0, 0], "ac": 1 },
			{ "type": Game.TileType.WALL, "wall_flags": [1, 0, 0, 0], "ac": 1 },
			{ "type": Game.TileType.WALL, "wall_flags": [1, 0, 0, 0], "ac": 1 },
			{ "type": Game.TileType.WALL, "wall_flags": [0, 1, 0, 0], "ac": 1 },
			{ "type": Game.TileType.WALL, "wall_flags": [0, 1, 0, 0], "ac": 1 },
			{ "type": Game.TileType.WALL, "wall_flags": [0, 1, 0, 0], "ac": 1 },
			{ "type": Game.TileType.WALL, "wall_flags": [0, 1, 0, 0], "ac": 1 },
			{ "type": Game.TileType.WALL, "wall_flags": [0, 0, 1, 0], "ac": 1 },
			{ "type": Game.TileType.WALL, "wall_flags": [0, 0, 1, 0], "ac": 1 },
			{ "type": Game.TileType.WALL, "wall_flags": [0, 0, 1, 0], "ac": 1 },
			{ "type": Game.TileType.WALL, "wall_flags": [0, 0, 1, 0], "ac": 1 },
			{ "type": Game.TileType.WALL, "wall_flags": [0, 0, 0, 1], "ac": 1 },
			{ "type": Game.TileType.WALL, "wall_flags": [0, 0, 0, 1], "ac": 1 },
			{ "type": Game.TileType.WALL, "wall_flags": [0, 0, 0, 1], "ac": 1 },
			{ "type": Game.TileType.WALL, "wall_flags": [0, 0, 0, 1], "ac": 1 },
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
