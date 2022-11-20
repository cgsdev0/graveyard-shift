extends Node

var starting_deck = [
	#                                            N  S  E  W
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
#	{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 1 },
#	{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 1 },
#	{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 1 },
#	{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 1 },
#	{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 1 },
#	{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 1 },
#	{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 1 },
#	{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 1 },
]

var deck = starting_deck.duplicate(true)

func _ready():
	Game.connect("reset", self, "on_reset")
	randomize()
	on_reset()

func on_reset():
	deck = starting_deck.duplicate(true)
	deck.shuffle()
	
func add_card(card):
	starting_deck.push_back(card)
	
func desired_count():
	return 4
	
func deal():
	return deck.pop_back()
