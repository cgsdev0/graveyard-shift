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
			#
]

var treasure_overrides = {
	1: [
		{ "type": Game.TileType.MONEY_TREE, "gpm": 4, "ac": 2, "level": 1 }
	],
	2: [
		{ "type": Game.TileType.BRIDGE, "wall_flags": [1000, 1000, 0, 0], "ac": 1 }
	],
	3: [
		[
			{ "type": Game.TileType.SECRET_DOOR, "wall_flags": [3, 0, 0, 0], "ac": 1 },
			{ "type": Game.TileType.SECRET_DOOR, "wall_flags": [0, 3, 0, 0], "ac": 1 },
			{ "type": Game.TileType.SECRET_DOOR, "wall_flags": [0, 0, 3, 0], "ac": 1 },
			{ "type": Game.TileType.SECRET_DOOR, "wall_flags": [0, 0, 0, 3], "ac": 1 },
		]
	],
	4: [
		{ "type": Game.TileType.SPIKES, "ac": 1 },
	],
	5: [
		{ "type": Game.TileType.WALL, "wall_flags": [2, 2, 2, 2], "ac": 2 },
		{ "type": Game.TileType.LURE, "range": "unlimited", "ac": 2, "level": 2 },
	],
	6: [
		{ "type": Game.TileType.GUST, "ac": 0, "direction": "left" },
		{ "type": Game.TileType.GUST, "ac": 0, "direction": "right" },
		{ "type": Game.TileType.GUST, "ac": 0, "direction": "up" },
		{ "type": Game.TileType.GUST, "ac": 0, "direction": "down" },
	],
	7: [
		{ "type": Game.TileType.WALL, "wall_flags": [2, 2, 2, 2], "ac": 2 },
	],
	8: [
		[
			{ "type": Game.TileType.SECRET_DOOR, "wall_flags": [3, 0, 0, 0], "ac": 1 },
			{ "type": Game.TileType.SECRET_DOOR, "wall_flags": [0, 3, 0, 0], "ac": 1 },
			{ "type": Game.TileType.SECRET_DOOR, "wall_flags": [0, 0, 3, 0], "ac": 1 },
			{ "type": Game.TileType.SECRET_DOOR, "wall_flags": [0, 0, 0, 3], "ac": 1 },
		],
		{ "type": Game.TileType.WALL, "wall_flags": [5, 5, 5, 5], "ac": 2 },
	]
}

var starting_deck = [
	# Level 0 cards
	[
		#
		{ "cost": 5, "type": Game.TileType.BRIDGE, "wall_flags": [1000, 1000, 0, 0], "ac": 1 },
		{ "cost": 5, "type": Game.TileType.BRIDGE, "wall_flags": [0, 0, 1000, 1000], "ac": 1 },
		#
		{ "cost": 10, "type": Game.TileType.MONEY_TREE, "gpm": 4, "ac": 2, "level": 1 },
		{ "cost": 10, "type": Game.TileType.MONEY_TREE, "gpm": 4, "ac": 2, "level": 1 },
		{ "cost": 10, "type": Game.TileType.MONEY_TREE, "gpm": 4, "ac": 2, "level": 1 },
		#
		{ "cost": 5, "type": Game.TileType.COURAGE, "ac": 1, "actions": 1 },
		{ "cost": 5, "type": Game.TileType.COURAGE, "ac": 1, "actions": 1 },
		{ "cost": 10, "type": Game.TileType.FRESH_START, "ac": 0 },
		{ "cost": 10, "type": Game.TileType.FRESH_START, "ac": 0 },
		#
		{ "cost": 20, "type": Game.TileType.LURE, "range": 2, "ac": 2, "level": 1 },
		{ "cost": 20, "type": Game.TileType.LURE, "range": 2, "ac": 2, "level": 1 },
	],
	# Level 1 cards
	[
		#                                            N  S  E  W
		{ "cost": 25, "type": Game.TileType.WALL, "wall_flags": [2, 0, 0, 0], "ac": 1 },
		{ "cost": 25, "type": Game.TileType.WALL, "wall_flags": [0, 2, 0, 0], "ac": 1 },
		{ "cost": 25, "type": Game.TileType.WALL, "wall_flags": [0, 0, 2, 0], "ac": 1 },
		{ "cost": 25, "type": Game.TileType.WALL, "wall_flags": [0, 0, 0, 2], "ac": 1 },
		{ "cost": 20, "type": Game.TileType.WALL, "wall_flags": [1, 1, 0, 0], "ac": 1 },
		{ "cost": 20, "type": Game.TileType.WALL, "wall_flags": [1, 0, 1, 0], "ac": 1 },
		{ "cost": 20, "type": Game.TileType.WALL, "wall_flags": [1, 0, 0, 1], "ac": 1 },
		{ "cost": 20, "type": Game.TileType.WALL, "wall_flags": [0, 1, 1, 0], "ac": 1 },
		{ "cost": 20, "type": Game.TileType.WALL, "wall_flags": [0, 1, 0, 1], "ac": 1 },
		{ "cost": 20, "type": Game.TileType.WALL, "wall_flags": [0, 0, 1, 1], "ac": 1 },
		#
		{ "cost": 20, "type": Game.TileType.MONEY_TREE, "gpm": 8, "ac": 2, "level": 2 },
		{ "cost": 20, "type": Game.TileType.MONEY_TREE, "gpm": 8, "ac": 2, "level": 2 },
		{ "cost": 20, "type": Game.TileType.MONEY_TREE, "gpm": 8, "ac": 2, "level": 2 },
		{ "cost": 20, "type": Game.TileType.MONEY_TREE, "gpm": 8, "ac": 2, "level": 2 },
		
		{ "cost": 30, "type": Game.TileType.ACTION_SURGE, "ac": 0, "actions": 2 },
		{ "cost": 30, "type": Game.TileType.ACTION_SURGE, "ac": 0, "actions": 2 },
		{ "cost": 30, "type": Game.TileType.ACTION_SURGE, "ac": 0, "actions": 2 },
		
	],
	# Level 2 cards
	[
		{ "cost": 50, "type": Game.TileType.TRAP, "ac": 1 },
		{ "cost": 50, "type": Game.TileType.TRAP, "ac": 1 },
		{ "cost": 40, "type": Game.TileType.FORESIGHT, "ac": 0 },
		{ "cost": 40, "type": Game.TileType.FORESIGHT, "ac": 0 },
		{ "cost": 35, "type": Game.TileType.GUST, "ac": 1, "direction": "left" },
		{ "cost": 35, "type": Game.TileType.GUST, "ac": 1, "direction": "right" },
		{ "cost": 35, "type": Game.TileType.GUST, "ac": 1, "direction": "up" },
		{ "cost": 35, "type": Game.TileType.GUST, "ac": 1, "direction": "down" },
		
		#
		{ "cost": 99, "type": Game.TileType.WALL, "wall_flags": [5, 5, 5, 5], "ac": 4 },
		{ "cost": 99, "type": Game.TileType.WALL, "wall_flags": [5, 5, 5, 5], "ac": 4 },
	],
]

#	{ "type": Game.TileType.GUST, "ac": 2, "direction": "right" },
#	{ "type": Game.TileType.FRESH_START, "ac": 0 },
#	{ "type": Game.TileType.ACTION_SURGE, "ac": 0, "actions": 2 },
#	{ "type": Game.TileType.FORESIGHT, "ac": 1 },

var deck

func _ready():
	Game.connect("hard_reset", self, "on_hard_reset")
	randomize()
	on_hard_reset()

func on_hard_reset():
	deck = starting_deck.duplicate(true)
	for i in range(deck.size()):
		deck[i].shuffle()

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
	
func deal_treasure(index):
	var card = treasure_overrides[Game.level][index].duplicate(true)
	if typeof(card) == TYPE_ARRAY:
		card.shuffle()
		card = card[0]
	card.treasure = true
	return card
