extends Node

var starting_wall_deck = [
	{ "type": Game.TileType.WALL, "wall_flags": 0b1000 },
	{ "type": Game.TileType.WALL, "wall_flags": 0b0100 },
	{ "type": Game.TileType.WALL, "wall_flags": 0b0010 },
	{ "type": Game.TileType.WALL, "wall_flags": 0b0001 },
]
var starting_item_deck = [
	{ "type": Game.TileType.SOLDIER },
	{ "type": Game.TileType.SOLDIER },
	{ "type": Game.TileType.LURE },
]

var wall_deck = starting_wall_deck.duplicate()
var item_deck = starting_item_deck.duplicate()

func _ready():
	Game.connect("reset", self, "on_reset")
	randomize()
	on_reset()

func on_reset():
	wall_deck = starting_wall_deck.duplicate()
	item_deck = starting_item_deck.duplicate()
	wall_deck.shuffle()
	item_deck.shuffle()
	
func deal_wall():
	return wall_deck.pop_back()
	
func deal_item():
	return item_deck.pop_back()
