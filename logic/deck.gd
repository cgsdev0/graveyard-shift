extends Node

var starting_deck = {
	Game.SlotType.WALL: {
		"cards": [
			{ "type": Game.TileType.WALL, "wall_flags": 0b1000 },
			{ "type": Game.TileType.WALL, "wall_flags": 0b0100 },
			{ "type": Game.TileType.WALL, "wall_flags": 0b0010 },
			{ "type": Game.TileType.WALL, "wall_flags": 0b0001 },
		],
		"desired_count": 2,
	 },
	 Game.SlotType.ITEM: {
		"cards": [
			{ "type": Game.TileType.SOLDIER },
			{ "type": Game.TileType.SOLDIER },
			{ "type": Game.TileType.LURE },
			{ "type": Game.TileType.TRAP },
		],
		"desired_count": 2,
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
	
func desired_count(slot_type):
	return deck[slot_type].desired_count
	
func deal(slot_type):
	return deck[slot_type].cards.pop_back()
