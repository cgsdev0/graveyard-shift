extends Node

var starting_treasure_deck = [
		#                       	                        N  S  E  W
		{ "type": Game.TileType.SECRET_DOOR, "wall_flags": [3, 0, 0, 0], "ac": 1 },
		{ "type": Game.TileType.SECRET_DOOR, "wall_flags": [0, 3, 0, 0], "ac": 1 },
		{ "type": Game.TileType.SECRET_DOOR, "wall_flags": [0, 0, 3, 0], "ac": 1 },
		{ "type": Game.TileType.SECRET_DOOR, "wall_flags": [0, 0, 0, 3], "ac": 1 },
		# legendary quad wall
		{ "type": Game.TileType.WALL, "wall_flags": [2, 2, 2, 2], "ac": 2 },
		{ "type": Game.TileType.WALL, "wall_flags": [2, 2, 2, 2], "ac": 2 },
		#
		{ "type": Game.TileType.SPIKES, "ac": 1 },
		{ "type": Game.TileType.SPIKES, "ac": 1 },
		#
		{ "type": Game.TileType.LURE, "range": "unlimited", "ac": 2 },
]

var starting_deck = [
	# Level 0 cards
	[
		#
		{ "cost": 5, "type": Game.TileType.BRIDGE, "wall_flags": [1000, 1000, 0, 0], "ac": 1 },
		{ "cost": 5, "type": Game.TileType.BRIDGE, "wall_flags": [0, 0, 1000, 1000], "ac": 1 },
		#
		{ "cost": 5, "type": Game.TileType.MONEY_TREE, "gpm": 5, "ac": 1 },
		{ "cost": 5, "type": Game.TileType.MONEY_TREE, "gpm": 5, "ac": 1 },
		{ "cost": 5, "type": Game.TileType.MONEY_TREE, "gpm": 5, "ac": 1 },
		#
		{ "cost": 5, "type": Game.TileType.COURAGE, "ac": 1, "actions": 1 },
		{ "cost": 5, "type": Game.TileType.COURAGE, "ac": 1, "actions": 1 },
		{ "cost": 5, "type": Game.TileType.FRESH_START, "ac": 0 },
		{ "cost": 5, "type": Game.TileType.FRESH_START, "ac": 0 },
		#
		{ "cost": 10, "type": Game.TileType.LURE, "range": 3, "ac": 2 },
	],
	# Level 1 cards
	[
		{ "cost": 10, "type": Game.TileType.LURE, "range": 3, "ac": 2 },
		#                                            N  S  E  W
		{ "cost": 10, "type": Game.TileType.WALL, "wall_flags": [2, 0, 0, 0], "ac": 1 },
		{ "cost": 10, "type": Game.TileType.WALL, "wall_flags": [0, 2, 0, 0], "ac": 1 },
		{ "cost": 10, "type": Game.TileType.WALL, "wall_flags": [0, 0, 2, 0], "ac": 1 },
		{ "cost": 10, "type": Game.TileType.WALL, "wall_flags": [0, 0, 0, 2], "ac": 1 },
		{ "cost": 10, "type": Game.TileType.WALL, "wall_flags": [1, 1, 0, 0], "ac": 1 },
		{ "cost": 10, "type": Game.TileType.WALL, "wall_flags": [1, 0, 1, 0], "ac": 1 },
		{ "cost": 10, "type": Game.TileType.WALL, "wall_flags": [1, 0, 0, 1], "ac": 1 },
		{ "cost": 10, "type": Game.TileType.WALL, "wall_flags": [0, 1, 1, 0], "ac": 1 },
		{ "cost": 10, "type": Game.TileType.WALL, "wall_flags": [0, 1, 0, 1], "ac": 1 },
		{ "cost": 10, "type": Game.TileType.WALL, "wall_flags": [0, 0, 1, 1], "ac": 1 },
		#
		{ "cost": 10, "type": Game.TileType.MONEY_TREE, "gpm": 10, "ac": 1 },
		{ "cost": 10, "type": Game.TileType.MONEY_TREE, "gpm": 10, "ac": 1 },
		{ "cost": 10, "type": Game.TileType.MONEY_TREE, "gpm": 10, "ac": 1 },
		{ "cost": 10, "type": Game.TileType.MONEY_TREE, "gpm": 10, "ac": 1 },
		
		{ "cost": 10, "type": Game.TileType.ACTION_SURGE, "ac": 0, "actions": 2 },
		{ "cost": 10, "type": Game.TileType.ACTION_SURGE, "ac": 0, "actions": 2 },
		{ "cost": 10, "type": Game.TileType.ACTION_SURGE, "ac": 0, "actions": 2 },
		
	],
	# Level 2 cards
	[
		{ "cost": 20, "type": Game.TileType.TRAP, "ac": 1 },
		{ "cost": 20, "type": Game.TileType.TRAP, "ac": 1 },
		{ "cost": 20, "type": Game.TileType.FORESIGHT, "ac": 0 },
		{ "cost": 20, "type": Game.TileType.FORESIGHT, "ac": 0 },
		{ "cost": 20, "type": Game.TileType.GUST, "ac": 2, "direction": "left" },
		{ "cost": 20, "type": Game.TileType.GUST, "ac": 2, "direction": "right" },
		{ "cost": 20, "type": Game.TileType.GUST, "ac": 2, "direction": "up" },
		{ "cost": 20, "type": Game.TileType.GUST, "ac": 2, "direction": "down" },
		
		#
		{ "cost": 20, "type": Game.TileType.WALL, "wall_flags": [9999, 9999, 9999, 9999], "ac": 4 },
	],
]

#	{ "type": Game.TileType.GUST, "ac": 2, "direction": "right" },
#	{ "type": Game.TileType.FRESH_START, "ac": 0 },
#	{ "type": Game.TileType.ACTION_SURGE, "ac": 0, "actions": 2 },
#	{ "type": Game.TileType.FORESIGHT, "ac": 1 },

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

func deal():
	var rarity = randf()
	var deck_i = 0
	if rarity > 0.85:
		deck_i = 2
	elif rarity > 0.6:
		deck_i = 1
	while deck[deck_i].size() == 0 && deck_i > 0:
		deck_i -= 1
	var card = deck[deck_i].pop_back()
	card.rarity = deck_i
	return card

func return_card(card):
	deck[card.rarity].push_back(card)
	deck[card.rarity].shuffle()
	
func deal_treasure():
	var card = treasure_deck.pop_back().duplicate(true)
	card.treasure = true
	return card
