extends Node

var starting_treasure_deck = [
		#                       	                        N  S  E  W
		{ "type": Game.TileType.SECRET_DOOR, "wall_flags": [3, 0, 0, 0], "ac": 1 },
		{ "type": Game.TileType.SECRET_DOOR, "wall_flags": [0, 3, 0, 0], "ac": 1 },
		{ "type": Game.TileType.SECRET_DOOR, "wall_flags": [0, 0, 3, 0], "ac": 1 },
		{ "type": Game.TileType.SECRET_DOOR, "wall_flags": [0, 0, 0, 3], "ac": 1 },
		#
		{ "type": Game.TileType.TRAP, "ac": 2 },
		{ "type": Game.TileType.TRAP, "ac": 2 },
		#
		{ "type": Game.TileType.LURE, "range": "unlimited", "ac": 2 },
		{ "type": Game.TileType.LURE, "range": "unlimited", "ac": 2 },
]

var starting_deck = [
	# Level 0 cards
	[
		#
		{ "cost": 0, "type": Game.TileType.LURE, "range": 3, "ac": 2 },
		{ "cost": 0, "type": Game.TileType.BRIDGE, "wall_flags": [1000, 1000, 0, 0], "ac": 1 },
		{ "cost": 0, "type": Game.TileType.BRIDGE, "wall_flags": [1000, 1000, 0, 0], "ac": 1 },
		{ "cost": 0, "type": Game.TileType.BRIDGE, "wall_flags": [0, 0, 1000, 1000], "ac": 1 },
		{ "cost": 0, "type": Game.TileType.BRIDGE, "wall_flags": [0, 0, 1000, 1000], "ac": 1 },
		#
		{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 2 },
		{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 2 },
		{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 2 },
	],
	# Level 1 cards
	[
		#                                            N  S  E  W
		{ "cost": 0, "type": Game.TileType.WALL, "wall_flags": [2, 0, 0, 0], "ac": 1 },
		{ "cost": 0, "type": Game.TileType.WALL, "wall_flags": [0, 2, 0, 0], "ac": 1 },
		{ "cost": 0, "type": Game.TileType.WALL, "wall_flags": [0, 0, 2, 0], "ac": 1 },
		{ "cost": 0, "type": Game.TileType.WALL, "wall_flags": [0, 0, 0, 2], "ac": 1 },
		{ "cost": 0, "type": Game.TileType.WALL, "wall_flags": [1, 1, 0, 0], "ac": 1 },
		{ "cost": 0, "type": Game.TileType.WALL, "wall_flags": [1, 0, 1, 0], "ac": 1 },
		{ "cost": 0, "type": Game.TileType.WALL, "wall_flags": [1, 0, 0, 1], "ac": 1 },
		{ "cost": 0, "type": Game.TileType.WALL, "wall_flags": [0, 1, 1, 0], "ac": 1 },
		{ "cost": 0, "type": Game.TileType.WALL, "wall_flags": [0, 1, 0, 1], "ac": 1 },
		{ "cost": 0, "type": Game.TileType.WALL, "wall_flags": [0, 0, 1, 1], "ac": 1 },
		#
		{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 2, "ac": 2 },
		{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 2, "ac": 2 },
		{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 2, "ac": 2 },
		{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 2, "ac": 2 },
	],
	# Level 2 cards
	[
		{ "cost": 0, "type": Game.TileType.TRAP, "ac": 2 },	
	],
]


var deck
var treasure_deck

func _ready():
	Game.connect("hard_reset", self, "on_hard_reset")
	randomize()
	on_hard_reset()

func on_hard_reset():
	deck = starting_deck.duplicate(true)
	treasure_deck = starting_treasure_deck.duplicate(true)
	for i in range(deck.size()):
		deck[i].shuffle()
	treasure_deck.shuffle()

func deal(i):
	return deck[i].pop_back()

func return_card(card, i):
	deck[i].push_back(card)
	deck[i].shuffle()
	
func deal_treasure():
	var card = treasure_deck.pop_back().duplicate(true)
	card.treasure = true
	return card
