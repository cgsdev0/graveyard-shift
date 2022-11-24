extends Node

var starting_deck = [
	#                                            N  S  E  W
	{ "type": Game.TileType.WALL, "wall_flags": [1, 0, 0, 0], "ac": 1 },
	{ "type": Game.TileType.WALL, "wall_flags": [1, 0, 0, 0], "ac": 1 },
	{ "type": Game.TileType.WALL, "wall_flags": [1, 0, 0, 0], "ac": 1 },
	{ "type": Game.TileType.WALL, "wall_flags": [0, 1, 0, 0], "ac": 1 },
	{ "type": Game.TileType.WALL, "wall_flags": [0, 1, 0, 0], "ac": 1 },
	{ "type": Game.TileType.WALL, "wall_flags": [0, 1, 0, 0], "ac": 1 },
	{ "type": Game.TileType.WALL, "wall_flags": [0, 0, 1, 0], "ac": 1 },
	{ "type": Game.TileType.WALL, "wall_flags": [0, 0, 1, 0], "ac": 1 },
	{ "type": Game.TileType.WALL, "wall_flags": [0, 0, 1, 0], "ac": 1 },
	# { "type": Game.TileType.WALL, "wall_flags": [0, 0, 0, 1], "ac": 1 },
	# { "type": Game.TileType.WALL, "wall_flags": [0, 0, 0, 1], "ac": 1 },
	# { "type": Game.TileType.WALL, "wall_flags": [0, 0, 0, 1], "ac": 1 },
#	{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 1 },
#	{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 1 },
#	{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 2 },
#	{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 1 },
#	{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 1 },
#	{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 1 },
#	{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 1 },
#	{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 1 },
	{ "type": Game.TileType.LURE, "range": "unlimited", "ac": 2 },
	{ "type": Game.TileType.LURE, "range": 3, "ac": 2 },
	{ "type": Game.TileType.GUST, "ac": 2, "direction": "right" },
]

var max_deck_size = 12
var selected_deck = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]

var deck = starting_deck.duplicate(true)

var pending_treasure_card = null #{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 1 }# null

static func card_color(card):
	match card.type:
		Game.TileType.WALL:
			if card.wall_flags.max() > 1:
				return Color.aqua
			return Color.blue
	return Color.red
	
func on_accept_treasure():
	if pending_treasure_card:
		add_card(pending_treasure_card)
		
func _ready():
	Game.connect("reset", self, "on_reset")
	Game.connect("accept_treasure", self, "on_accept_treasure")
	randomize()
	on_reset()

func on_reset():
	deck = []
	for i in selected_deck:
		deck.push_back(starting_deck[i].duplicate(true))
	# TODO: re-enable
	# deck.shuffle()
	
func add_card(card):
	starting_deck.push_front(card)
	for i in range(selected_deck.size()):
		selected_deck[i] += 1
	
func desired_count():
	return 4
	
func deal():
	return deck.pop_back()
