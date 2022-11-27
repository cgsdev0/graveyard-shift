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
#	{ "type": Game.TileType.WALL, "wall_flags": [0, 0, 0, 1], "ac": 1 },
#	{ "type": Game.TileType.SPIKES, "ac": 1 }
#
#{ "cost": 40, "type": Game.TileType.FORESIGHT, "ac": 0 },
#{ "cost": 40, "type": Game.TileType.FORESIGHT, "ac": 0 },
#{ "cost": 40, "type": Game.TileType.FORESIGHT, "ac": 0 },
#{ "cost": 40, "type": Game.TileType.FORESIGHT, "ac": 0 },
#{ "cost": 40, "type": Game.TileType.FORESIGHT, "ac": 0 },
#{ "cost": 40, "type": Game.TileType.FORESIGHT, "ac": 0 },
#{ "cost": 40, "type": Game.TileType.FORESIGHT, "ac": 0 },
#{ "cost": 40, "type": Game.TileType.FORESIGHT, "ac": 0 },
#{ "cost": 40, "type": Game.TileType.FORESIGHT, "ac": 0 },
#{ "cost": 40, "type": Game.TileType.FORESIGHT, "ac": 0 },
#{ "cost": 40, "type": Game.TileType.FORESIGHT, "ac": 0 },
#{ "cost": 40, "type": Game.TileType.FORESIGHT, "ac": 0 },
#	{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 1 },
#	{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 1 },
#	{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 2 },
#	{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 1 },
#	{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 1 },
#	{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 1 },
#	{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 1 },
#	{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 1 },
#	{ "type": Game.TileType.LURE, "range": "unlimited", "ac": 2 },
	{ "type": Game.TileType.LURE, "range": 2, "ac": 2 },
#	{ "cost": 0, "type": Game.TileType.BRIDGE, "wall_flags": [1000, 1000, 0, 0], "ac": 1 },
#	{ "cost": 0, "type": Game.TileType.BRIDGE, "wall_flags": [0, 0, 1000, 1000], "ac": 1 },

]

var max_deck_size = 12
var selected_deck = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]

var deck = starting_deck.duplicate(true)

var pending_treasure_card = null #{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 1 }# null

static func card_color(card):
	if card.has('treasure'):
		return Color.salmon
	match card.get("rarity", 0):
		0:
			return Color.steelblue
		1:
			return Color.webmaroon
		2:
			return Color.rebeccapurple
	return Color.purple
	
func on_accept_treasure():
	if pending_treasure_card:
		add_card(pending_treasure_card)
		pending_treasure_card = null
		
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
	
func return_card(card):
	deck.push_front(card)
	deck.shuffle()
	
func desired_count():
	return 4
	
func deal():
	return deck.pop_back()
	
func empty():
	return deck.empty()
