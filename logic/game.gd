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
	
	FRESH_START,
	FORESIGHT,
	ACTION_SURGE,
	COURAGE,
	GUST,
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
		"turns": 4,
		"camera": {
			"zoom": 21,
			"angle": 40,
			"up": 0.3,
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
			"up": 0.0,
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
			"up": 0.0,
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

const descriptions = {
	TileType.WALL: "Blocks the path of all entities; monsters can break it down.",
	TileType.SECRET_DOOR: "Monsters cannot pass, but adventurers can. Can still be destroyed.",
	TileType.MONEY_TREE: "Earn {gpm} gold at the end of every turn. Can also serve as a basic wall.",
	TileType.LURE: "Lure monsters to a particular tile. Range: {range} tiles",
	TileType.BRIDGE: "Creates a path over open graves.",
	TileType.SPIKES: "Stops an entity in its tracks. Takes one turn to become active.",
	TileType.TRAP: "If a monster ends its turn on this tile, its next turn will be skipped.",
	TileType.FRESH_START: "Redraw your entire hand.",
	TileType.FORESIGHT: "View the top 3 cards of the deck; add one to your hand.",
	TileType.COURAGE: "Give your adventurer an extra action this turn.",
	TileType.ACTION_SURGE: "Give yourself an extra action this turn.",
	TileType.GUST: "Push an entity one tile in any direction.",
}

const flavor = {
	TileType.WALL: "A sturdy stone wall.",
	TileType.SECRET_DOOR: "A stone wall with a secret passage...",
	TileType.MONEY_TREE: "Money DOES grow on trees!",
	TileType.LURE: "An irresistable treat.",
	TileType.BRIDGE: "Don't burn bridges, build them!",
	TileType.SPIKES: "A deadly trap hidden in the floor.",
	TileType.TRAP: "Tricky to master, but incredibly powerful.",
	TileType.FRESH_START: "Gotta know when to fold 'em...",
	TileType.FORESIGHT: "It won't tell you the lotto numbers, sadly",
	TileType.COURAGE: "Smells suspiciously like whiskey...",
	TileType.ACTION_SURGE: "That sweet taste of victory.",
	TileType.GUST: "Try pushing them into a pit",
}

const title = {
	TileType.WALL: "Wall",
	TileType.SECRET_DOOR: "Secret Door",
	TileType.MONEY_TREE: "Money Tree",
	TileType.LURE: "Lure",
	TileType.BRIDGE: "Bridge",
	TileType.SPIKES: "Spike Trap",
	TileType.TRAP: "Bear Trap",
	TileType.FRESH_START: "Fresh Start",
	TileType.FORESIGHT: "Foresight",
	TileType.COURAGE: "Courage",
	TileType.ACTION_SURGE: "Action Surge",
	TileType.GUST: "Gust of Wind",
}

static func title_card(card):
	if card.type == TileType.WALL:
		if card.wall_flags.max() > 1:
			return "Reinforced Wall"
	return title[card.type]
	
static func describe_card(card):
	return descriptions[card.type].format(card)
	
static func flavor_text_card(card):
	return flavor[card.type].format(card)
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
var is_turn = false

func on_reset():
	is_turn = false
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
signal daylight_animation_done
signal you_win
signal reset
signal prep_new_turn
signal deal_new_turn
signal start_new_turn
signal end_turn

signal accept_treasure
signal change_scene(path)
signal soft_reset
