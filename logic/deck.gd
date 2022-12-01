extends Node

var developer_deck = [
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
	{ "type": Game.TileType.MONEY_TREE, "gpm": 3, "ac": 2, "level": 1 },
	{ "type": Game.TileType.WALL, "wall_flags": [1, 1, 1, 1], "ac": 1 },
	{ "type": Game.TileType.LURE, "range": "unlimited", "ac": 2, "level": 2 },
	{ "cost": 5, "type": Game.TileType.BRIDGE, "wall_flags": [1000, 1000, 0, 0], "ac": 1 },
	{ "cost": 5, "type": Game.TileType.BRIDGE, "wall_flags": [0, 0, 1000, 1000], "ac": 1 },
	{ "cost": 10, "type": Game.TileType.MONEY_TREE, "gpm": 4, "ac": 2, "level": 1 },
	{ "cost": 10, "type": Game.TileType.MONEY_TREE, "gpm": 4, "ac": 2, "level": 1 },
	{ "cost": 10, "type": Game.TileType.MONEY_TREE, "gpm": 4, "ac": 2, "level": 1 },
	{ "cost": 5, "type": Game.TileType.COURAGE, "ac": 1, "actions": 1 },
	{ "cost": 5, "type": Game.TileType.COURAGE, "ac": 1, "actions": 1 },
	{ "cost": 10, "type": Game.TileType.FRESH_START, "ac": 0 },
	{ "cost": 10, "type": Game.TileType.FRESH_START, "ac": 0 },
	{ "cost": 20, "type": Game.TileType.LURE, "range": 2, "ac": 2, "level": 1 },
	{ "cost": 20, "type": Game.TileType.LURE, "range": 2, "ac": 2, "level": 1 },
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
	{ "cost": 20, "type": Game.TileType.MONEY_TREE, "gpm": 8, "ac": 2, "level": 2 },
	{ "cost": 20, "type": Game.TileType.MONEY_TREE, "gpm": 8, "ac": 2, "level": 2 },
	{ "cost": 20, "type": Game.TileType.MONEY_TREE, "gpm": 8, "ac": 2, "level": 2 },
	{ "cost": 20, "type": Game.TileType.MONEY_TREE, "gpm": 8, "ac": 2, "level": 2 },
	{ "cost": 30, "type": Game.TileType.ACTION_SURGE, "ac": 0, "actions": 2 },
	{ "cost": 30, "type": Game.TileType.ACTION_SURGE, "ac": 0, "actions": 2 },
	{ "cost": 30, "type": Game.TileType.ACTION_SURGE, "ac": 0, "actions": 2 },
	{ "cost": 50, "type": Game.TileType.TRAP, "ac": 1 },
	{ "cost": 50, "type": Game.TileType.TRAP, "ac": 1 },
	{ "cost": 40, "type": Game.TileType.FORESIGHT, "ac": 0 },
	{ "cost": 40, "type": Game.TileType.FORESIGHT, "ac": 0 },
	{ "cost": 35, "type": Game.TileType.GUST, "ac": 2, "direction": "left" },
	{ "cost": 35, "type": Game.TileType.GUST, "ac": 2, "direction": "right" },
	{ "cost": 35, "type": Game.TileType.GUST, "ac": 2, "direction": "up" },
	{ "cost": 35, "type": Game.TileType.GUST, "ac": 2, "direction": "down" },
	{ "cost": 99, "type": Game.TileType.WALL, "wall_flags": [5, 5, 5, 5], "ac": 4 },
	{ "cost": 99, "type": Game.TileType.WALL, "wall_flags": [5, 5, 5, 5], "ac": 4 },
]

var starting_deck = [
#	{ "type": Game.TileType.SPIKES, "ac": 1 },
#{ "type": Game.TileType.SPIKES, "ac": 1 },
#{ "type": Game.TileType.SPIKES, "ac": 1 },
#{ "type": Game.TileType.SPIKES, "ac": 1 },
#{ "type": Game.TileType.SPIKES, "ac": 1 },
#{ "type": Game.TileType.SPIKES, "ac": 1 },
#{ "type": Game.TileType.SPIKES, "ac": 1 },
#{ "type": Game.TileType.SPIKES, "ac": 1 },
#{ "type": Game.TileType.SPIKES, "ac": 1 },
#{ "type": Game.TileType.SPIKES, "ac": 1 },
#{ "type": Game.TileType.SPIKES, "ac": 1 },
#{ "type": Game.TileType.SPIKES, "ac": 1 },
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


#{ "type": Game.TileType.LURE, "range": 2, "ac": 2, "level": 1 },
#{ "type": Game.TileType.LURE, "range": 2, "ac": 2, "level": 1 },
#{ "type": Game.TileType.LURE, "range": 2, "ac": 2, "level": 1 },
#{ "type": Game.TileType.LURE, "range": 2, "ac": 2, "level": 1 },
#{ "type": Game.TileType.LURE, "range": 2, "ac": 2, "level": 1 },
#{ "type": Game.TileType.LURE, "range": 2, "ac": 2, "level": 1 },
#{ "type": Game.TileType.LURE, "range": 2, "ac": 2, "level": 1 },
#{ "type": Game.TileType.LURE, "range": 2, "ac": 2, "level": 1 },
#{ "type": Game.TileType.LURE, "range": 2, "ac": 2, "level": 1 },
#{ "type": Game.TileType.LURE, "range": 2, "ac": 2, "level": 1 },
#{ "type": Game.TileType.LURE, "range": 2, "ac": 2, "level": 1 },
#{ "type": Game.TileType.LURE, "range": 2, "ac": 2, "level": 1 },
#{ "type": Game.TileType.LURE, "range": 2, "ac": 2, "level": 1 },
#{ "type": Game.TileType.LURE, "range": 2, "ac": 2, "level": 1 },
#{ "type": Game.TileType.LURE, "range": 2, "ac": 2, "level": 1 },
#{ "type": Game.TileType.LURE, "range": 2, "ac": 2, "level": 1 },
#{ "type": Game.TileType.LURE, "range": 2, "ac": 2, "level": 1 },
#{ "type": Game.TileType.LURE, "range": 2, "ac": 2, "level": 1 },
#{ "type": Game.TileType.LURE, "range": 2, "ac": 2, "level": 1 },
#{ "type": Game.TileType.LURE, "range": 2, "ac": 2, "level": 1 },
#{ "type": Game.TileType.LURE, "range": 2, "ac": 2, "level": 1 },
#{ "type": Game.TileType.LURE, "range": 2, "ac": 2, "level": 1 },
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
# { "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 1, "level": 1 },
#	{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 1 },
#	{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 2 },
#	{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 1 },
#	{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 1 },
#	{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 1 },
#	{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 1 },
#	{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 1 },
#	{ "type": Game.TileType.LURE, "range": "unlimited", "ac": 2 },
#	{ "type": Game.TileType.GUST,  "direction": "down", "ac": 2 },
#	{ "type": Game.TileType.GUST,  "direction": "left", "ac": 0 },
#	{ "cost": 0, "type": Game.TileType.BRIDGE, "wall_flags": [1000, 1000, 0, 0], "ac": 1 },
#	{ "cost": 0, "type": Game.TileType.BRIDGE, "wall_flags": [0, 0, 1000, 1000], "ac": 1 },

]

var max_deck_size = 12
var starting_selected_deck = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]

var selected_deck = starting_selected_deck.duplicate(true)
var deck = starting_deck.duplicate(true)

var pending_treasure_card = null #{ "cost": 0, "type": Game.TileType.MONEY_TREE, "gpm": 1, "ac": 1 }# null

static func card_color(card):
	if card.has('treasure'):
		return Color.orange
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
		
func on_hard_reset():
	pending_treasure_card = null
	selected_deck = starting_selected_deck.duplicate(true)
	deck = starting_deck.duplicate(true)
	on_reset()
	
func _ready():
	Game.connect("reset", self, "on_reset")
	Game.connect("accept_treasure", self, "on_accept_treasure")
	Game.connect("hard_reset", self, "on_hard_reset")
	randomize()
	on_reset()

func on_reset():
	deck = []
	for i in selected_deck:
		deck.push_back(starting_deck[i].duplicate(true))
	# TODO: re-enable
	deck.shuffle()
	
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
