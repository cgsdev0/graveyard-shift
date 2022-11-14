extends Node


enum TileType {
	EMPTY,
	PIT,
	TREASURE,
	TREASURE_TAKEN,
	
	SECRET_DOOR,
	WALL,
	SOLDIER,
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

var levels = [
	# Level 0
	{
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
	# Level 1
	{
		"cols": 3,
		"rows": 3,
		"tiles": [
			[2, 2, TileType.EXIT],
			[0, 1, TileType.PIT],
			[2, 1, TileType.PIT],
		],
		"monsters": [
			[0, 0, MonsterType.WALKER]
		]
	},
	# Level 2
	{
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
			
var level = 0

func get_board():
	return get_tree().root.find_node("Board", true, false)
	
signal select_card(card)

signal start_drag(card)
signal start_hover(card)
signal end_hover(card)

signal game_over
signal reset
signal start_new_turn
signal end_turn
