extends Node

enum TileType {
	EMPTY,
	PIT,
	TREASURE,
	
	WALL,
	SOLDIER,
	LURE,
	TRAP,
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
			
			
signal select_card(card)
