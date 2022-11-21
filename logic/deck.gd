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
	{ "type": Game.TileType.WALL, "wall_flags": [0, 0, 0, 1], "ac": 1 },
	{ "type": Game.TileType.WALL, "wall_flags": [0, 0, 0, 1], "ac": 1 },
	{ "type": Game.TileType.WALL, "wall_flags": [0, 0, 0, 1], "ac": 1 },
#	{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 1 },
#	{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 1 },
#	{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 2 },
#	{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 1 },
#	{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 1 },
#	{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 1 },
#	{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 1 },
#	{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 1 },
]

var max_deck_size = 12
var selected_deck = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]

var deck = starting_deck.duplicate(true)

static func card_color(card):
	match card.type:
		Game.TileType.WALL:
			if card.wall_flags.max() > 1:
				return Color.aqua
			return Color.blue
	return Color.red
	
func _ready():
	Game.connect("reset", self, "on_reset")
	randomize()
	on_reset()

func on_reset():
	deck = starting_deck.duplicate(true)
	deck.shuffle()
	
func add_card(card):
	starting_deck.push_front(card)
	for i in range(selected_deck.size()):
		selected_deck[i] += 1
	
func desired_count():
	return 4
	
func deal():
	return deck.pop_back()
