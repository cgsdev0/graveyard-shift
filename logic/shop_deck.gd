extends Node

var starting_treasure_deck = [
		[
			{ "type": Game.TileType.MONEY_TREE, "gpm": 3, "ac": 2 },
		],
		[
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
		],
]

var starting_deck = [
	# Level 0 cards
	[
		#
		{ "cost": 8, "type": Game.TileType.BRIDGE, "wall_flags": [1000, 1000, 0, 0], "ac": 1 },
		{ "cost": 8, "type": Game.TileType.BRIDGE, "wall_flags": [0, 0, 1000, 1000], "ac": 1 },
		#
		{ "cost": 10, "type": Game.TileType.MONEY_TREE, "gpm": 3, "ac": 2 },
		{ "cost": 10, "type": Game.TileType.MONEY_TREE, "gpm": 3, "ac": 2 },
		{ "cost": 10, "type": Game.TileType.MONEY_TREE, "gpm": 3, "ac": 2 },
		#
		{ "cost": 8, "type": Game.TileType.COURAGE, "ac": 1, "actions": 1 },
		{ "cost": 8, "type": Game.TileType.COURAGE, "ac": 1, "actions": 1 },
		{ "cost": 9, "type": Game.TileType.FRESH_START, "ac": 0 },
		{ "cost": 9, "type": Game.TileType.FRESH_START, "ac": 0 },
		#
		{ "cost": 20, "type": Game.TileType.LURE, "range": 3, "ac": 2 },
		{ "cost": 20, "type": Game.TileType.LURE, "range": 3, "ac": 2 },
	],
	# Level 1 cards
	[
		#                                            N  S  E  W
		{ "cost": 27, "type": Game.TileType.WALL, "wall_flags": [2, 0, 0, 0], "ac": 1 },
		{ "cost": 27, "type": Game.TileType.WALL, "wall_flags": [0, 2, 0, 0], "ac": 1 },
		{ "cost": 27, "type": Game.TileType.WALL, "wall_flags": [0, 0, 2, 0], "ac": 1 },
		{ "cost": 27, "type": Game.TileType.WALL, "wall_flags": [0, 0, 0, 2], "ac": 1 },
		{ "cost": 24, "type": Game.TileType.WALL, "wall_flags": [1, 1, 0, 0], "ac": 1 },
		{ "cost": 24, "type": Game.TileType.WALL, "wall_flags": [1, 0, 1, 0], "ac": 1 },
		{ "cost": 24, "type": Game.TileType.WALL, "wall_flags": [1, 0, 0, 1], "ac": 1 },
		{ "cost": 24, "type": Game.TileType.WALL, "wall_flags": [0, 1, 1, 0], "ac": 1 },
		{ "cost": 24, "type": Game.TileType.WALL, "wall_flags": [0, 1, 0, 1], "ac": 1 },
		{ "cost": 24, "type": Game.TileType.WALL, "wall_flags": [0, 0, 1, 1], "ac": 1 },
		#
		{ "cost": 20, "type": Game.TileType.MONEY_TREE, "gpm": 5, "ac": 2 },
		{ "cost": 20, "type": Game.TileType.MONEY_TREE, "gpm": 5, "ac": 2 },
		{ "cost": 20, "type": Game.TileType.MONEY_TREE, "gpm": 5, "ac": 2 },
		{ "cost": 20, "type": Game.TileType.MONEY_TREE, "gpm": 5, "ac": 2 },
		
		{ "cost": 30, "type": Game.TileType.ACTION_SURGE, "ac": 0, "actions": 2 },
		{ "cost": 30, "type": Game.TileType.ACTION_SURGE, "ac": 0, "actions": 2 },
		{ "cost": 30, "type": Game.TileType.ACTION_SURGE, "ac": 0, "actions": 2 },
		
	],
	# Level 2 cards
	[
		{ "cost": 75, "type": Game.TileType.TRAP, "ac": 1 },
		{ "cost": 75, "type": Game.TileType.TRAP, "ac": 1 },
		{ "cost": 40, "type": Game.TileType.FORESIGHT, "ac": 0 },
		{ "cost": 40, "type": Game.TileType.FORESIGHT, "ac": 0 },
		{ "cost": 35, "type": Game.TileType.GUST, "ac": 2, "direction": "left" },
		{ "cost": 35, "type": Game.TileType.GUST, "ac": 2, "direction": "right" },
		{ "cost": 35, "type": Game.TileType.GUST, "ac": 2, "direction": "up" },
		{ "cost": 35, "type": Game.TileType.GUST, "ac": 2, "direction": "down" },
		
		#
		{ "cost": 100, "type": Game.TileType.WALL, "wall_flags": [9999, 9999, 9999, 9999], "ac": 4 },
		{ "cost": 100, "type": Game.TileType.WALL, "wall_flags": [9999, 9999, 9999, 9999], "ac": 4 },
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
	for i in range(treasure_deck.size()):
		treasure_deck[i].shuffle()

func rarities():
	return [
		0.95 - clamp(Game.level * 0.015, 0, 0.45),
		0.75 - clamp(Game.level * 0.030, 0, 0.5)
	]
	
func deal():
	var rarity = randf()
	var r = rarities()
	var deck_i = 0
	if rarity > r[0]:
		deck_i = 2
	elif rarity > r[1]:
		deck_i = 1
		
	# Lower rarity if we're out of stock
	while deck[deck_i].size() == 0 && deck_i > 0:
		deck_i -= 1
		
	# Raise rarity if we're still out of stock
	while deck[deck_i].size() == 0 && deck_i < deck.size() - 1:
		deck_i += 1
		
	var card = deck[deck_i].pop_back()
	if !card:
		return null
	card.rarity = deck_i
	return card

func return_card(card):
	deck[card.rarity].push_back(card)
	deck[card.rarity].shuffle()
	
func deal_treasure():
	var card = treasure_deck[0].pop_back().duplicate(true)
	if treasure_deck[0].empty() && treasure_deck.size() > 1:
		treasure_deck.pop_front()
	card.treasure = true
	return card
