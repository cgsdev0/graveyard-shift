extends Node

enum SlotType {
	WALL,
	ITEM
}

enum TileType {
	EMPTY,
	PIT,
	TREASURE,
	TREASURE_TAKEN,
	
	BRIDGE,
	SECRET_DOOR,
	WALL,
	MONEY_TREE,
	LURE,
	TRAP,
	TRAP_SPRUNG,
	SPIKES,
	# keep this one last
	EXIT
}

enum Direction {
	NORTH,
	SOUTH,
	EAST,
	WEST
}

enum MonsterType {
	WALKER,
	SPRINTER
}

var original_theme

var levels = [
	# Level 0
	{
		"turns": 1,
		"camera": {
			"zoom": 18,
			"angle": 40,
		},
		"cols": 3,
		"rows": 3,
		"tiles": [
			[2, 0, TileType.EXIT],
			[1, 0, TileType.PIT],
			[1, 1, TileType.PIT],
		],
		"monsters": [
			[0, 0, MonsterType.WALKER]
		]
	},
	# Level 1
	{
		"turns": 6,
		"camera": {
			"zoom": 27,
			"angle": 40,
		},
		"cols": 5,
		"rows": 4,
		"tiles": [
			[4, 3, TileType.EXIT],
			[2, 0, TileType.TREASURE],
			[0, 3, TileType.PIT],
			[2, 2, TileType.PIT],
			[3, 1, TileType.PIT],
		],
		"monsters": [
			[0, 0, MonsterType.SPRINTER]
		]
	},
	# Level 2
	{
		"turns": 3,
		"camera": {
			"zoom": 35,
			"angle": 40,
		},
		"cols": 6,
		"rows": 6,
		"tiles": [
			[5, 5, TileType.EXIT],
		],
		"monsters": [
			[0, 0, MonsterType.SPRINTER]
		]
	}
]

static func is_wall(tile_type):
	match tile_type:
		TileType.WALL, TileType.SECRET_DOOR, TileType.BRIDGE:
			return true
	return false

static func invert_direction(direction):
	match direction:
		Direction.NORTH:
			return Direction.SOUTH
		Direction.SOUTH:
			return Direction.NORTH
		Direction.WEST:
			return Direction.EAST
		Direction.EAST:
			return Direction.WEST

# Game State
var level = 0
var turns = 0
var max_turns = 0
var actions = 2
var actions_per_turn = 2

var money = 0
var money_at_start = 0
var is_turn = true

func on_reset():
	is_turn = true
	turns = float(levels[level].turns)
	actions = actions_per_turn
	max_turns = turns
	money_at_start = money
	
func reset_money():
	money = money_at_start

func _ready():
	self.connect("reset", self, "on_reset")
	self.connect("end_turn", self, "on_end_turn")
	self.connect("start_new_turn", self, "on_start_new_turn")
	on_reset()

func on_start_new_turn():
	is_turn = true
	
func on_end_turn():
	is_turn = false
	
func get_board():
	return get_tree().root.find_node("Board", true, false)
	
signal start_drag(card, pos)
signal start_hover(card)
signal end_hover(card)

signal game_over
signal you_win
signal reset
signal prep_new_turn
signal start_new_turn
signal end_turn
