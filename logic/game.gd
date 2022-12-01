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

func gust_direction(dir):
	match dir:
		"left":
			return Direction.WEST
		"right":
			return Direction.EAST
		"up":
			return Direction.NORTH
		"down": 
			return Direction.SOUTH

enum MonsterType {
	WALKER,
	SPRINTER,
	SLIME
}

var original_theme

var levels = [
	# Level 0 - introduce game
	{
		"turns": 4,
		"camera": {
			"zoom": 21,
			"angle": 40,
			"up": 0.5,
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
	# Level 1 - introduce adventurer
	{
		"turns": 4,
		"camera": {
			"zoom": 23,
			"angle": 40,
			"up": 0.4,
		},
		"cols": 4,
		"rows": 3,
		"tiles": [
			[3, 2, TileType.EXIT],
			[1, 0, TileType.PIT],
			[2, 2, TileType.PIT],
			[3, 0, TileType.TREASURE],
		],
		"monsters": [
			[0, 0, MonsterType.WALKER]
		]
	},
	# Level 2
	{
		"turns": 4,
		"camera": {
			"zoom": 25,
			"angle": 40,
			"up": 0.4,
		},
		"cols": 4,
		"rows": 4,
		"tiles": [
			[2, 2, TileType.EXIT],
			[0, 0, TileType.PIT],
			[2, 1, TileType.PIT],
			[1, 2, TileType.PIT],
			[3, 3, TileType.PIT],
			[0, 3, TileType.TREASURE],
		],
		"monsters": [
			[1, 1, MonsterType.WALKER]
		]
	},
	# Level 3
	{
		"turns": 5,
		"camera": {
			"zoom": 26,
			"angle": 40,
			"up": 0.4,
		},
		"cols": 5,
		"rows": 4,
		"tiles": [
			[2, 2, TileType.EXIT],
			[0, 2, TileType.TREASURE],
			[3, 0, TileType.PIT],
			[3, 2, TileType.PIT],
			[1, 2, TileType.PIT],
			[2, 3, TileType.PIT],
		],
		"monsters": [
			[3, 3, MonsterType.WALKER]
		]
	},
	# Level 4 - introduce roller
	{
		"turns": 5,
		"camera": {
			"zoom": 26,
			"angle": 40,
			"up": 0.4,
		},
		"cols": 5,
		"rows": 4,
		"tiles": [
			[0, 0, TileType.EXIT],
			[1, 3, TileType.TREASURE],
			[1, 0, TileType.PIT],
			[1, 1, TileType.PIT],
			[1, 2, TileType.PIT],
			[3, 1, TileType.PIT],
			[3, 2, TileType.PIT],
			[3, 3, TileType.PIT],
		],
		"monsters": [
			[4, 3, MonsterType.SPRINTER]
		]
	},
		# Level 5
	{
		"turns": 6,
		"camera": {
			"zoom": 28,
			"angle": 40,
			"up": 0.0,
		},
		"cols": 5,
		"rows": 5,
		"tiles": [
			[2, 4, TileType.EXIT],
			[4, 2, TileType.TREASURE],
			[0, 4, TileType.TREASURE],
			[0, 0, TileType.PIT],
			[0, 3, TileType.PIT],
			[4, 0, TileType.PIT],
			[2, 3, TileType.PIT],
			[1, 4, TileType.PIT],
		],
		"monsters": [
			[0, 1, MonsterType.WALKER]
		]
	},
	# Level 6
	{
		"turns": 5,
		"camera": {
			"zoom": 26,
			"angle": 40,
			"up": 0.4,
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
	# Level 7 - slime time
	{
		"turns": 4,
		"camera": {
			"zoom": 28,
			"angle": 40,
			"up": 0.0,
		},
		"cols": 5,
		"rows": 5,
		"tiles": [
			[2, 2, TileType.EXIT],
			[4, 4, TileType.TREASURE],
			[1, 1, TileType.PIT],
			[3, 1, TileType.PIT],
			[3, 3, TileType.PIT],
			[1, 3, TileType.PIT],
		],
		"monsters": [
			[2, 0, MonsterType.SLIME],
			[0, 1, MonsterType.SLIME],
			[4, 1, MonsterType.SLIME],
		]
	},
	# Level 8 - twice the fun
	{
		"turns": 5,
		"camera": {
			"zoom": 28,
			"angle": 40,
			"up": 0.0,
		},
		"cols": 5,
		"rows": 5,
		"tiles": [
			[2, 2, TileType.EXIT],
			[0, 3, TileType.TREASURE],
			[3, 4, TileType.TREASURE],
			[0, 1, TileType.PIT],
			[3, 1, TileType.PIT],
			[1, 1, TileType.PIT],
			[2, 1, TileType.PIT],
			[2, 3, TileType.PIT],
			[3, 3, TileType.PIT],
			[4, 3, TileType.PIT],
		],
		"monsters": [
			[0, 0, MonsterType.SPRINTER],
			[4, 4, MonsterType.WALKER],
		]
	},
	# Level 9
	{
		"turns": 8, # 8
		"camera": {
			"zoom": 35,
			"angle": 40,
			"up": 0.0,
		},
		"cols": 6,
		"rows": 6,
		"tiles": [
			[1, 1, TileType.EXIT],
			[1, 0, TileType.PIT],
			[0, 1, TileType.PIT],
			[2, 2, TileType.PIT],
			[3, 3, TileType.PIT],
			[4, 4, TileType.PIT],
			[5, 5, TileType.PIT],
		],
		"monsters": [
			[0, 4, MonsterType.SLIME],
			[0, 5, MonsterType.SLIME],
			[1, 5, MonsterType.SLIME],
			[4, 0, MonsterType.SLIME],
			[5, 0, MonsterType.SLIME],
			[5, 1, MonsterType.SLIME],
		]
	}
]

const descriptions = {
	TileType.WALL: "Blocks and re-routes entities; monsters can attack it to bring it down.",
	TileType.SECRET_DOOR: "Monsters cannot pass, but adventurers can. Can still be destroyed.",
	TileType.MONEY_TREE: "Earn {gpm} gold at the end of every turn. Can also serve as a primitive wall.",
	TileType.LURE: "Lure monsters to a particular tile. Range: {range} tiles",
	TileType.BRIDGE: "Creates a path over open graves.",
	TileType.SPIKES: "Stops an entity in its tracks and stuns for 1 turn. Takes one turn to become active.",
	TileType.TRAP: "If a monster ends its turn on this tile, it will be stunned next turn.",
	TileType.FRESH_START: "Redraw your entire hand.",
	TileType.FORESIGHT: "Draw 3 cards; add one to your hand. Shuffle the others back into the deck.",
	TileType.COURAGE: "Give your adventurer {actions} extra action(s) this turn. Also, they will go first.",
	TileType.ACTION_SURGE: "Give yourself {actions} extra action(s) this turn.",
	TileType.GUST: "Push an entity one tile {direction}. Cannot push entities off the board.",
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
	TileType.SPIKES: "Floor Spikes",
	TileType.TRAP: "Bear Trap",
	TileType.TRAP_SPRUNG: "Trap (Sprung)",
	TileType.FRESH_START: "Fresh Start",
	TileType.FORESIGHT: "Foresight",
	TileType.COURAGE: "Courage",
	TileType.ACTION_SURGE: "Action Surge",
	TileType.GUST: "Gust ({direction})",
	TileType.EXIT: "Exit",
	TileType.PIT: "Pit",
	TileType.TREASURE: "Treasure",
	TileType.TREASURE_TAKEN: "Treasure",
}

static func title_card(card):
	# Define some overrides
	if card.type == TileType.WALL && card.wall_flags.max() == 2:
		return "Reinforced Wall"
	if card.type == TileType.WALL && card.wall_flags.max() == 5:
		return "Fortress Wall"
	if card.type == TileType.LURE && typeof(card.range) == TYPE_STRING:
		return "Super Lure"
	if typeof(card) == TYPE_DICTIONARY || typeof(card) == TYPE_ARRAY:
		return title[card.type].format(card)
	# fallback
	return title[card.type]
	
static func describe_card(card):
	var describe = ""
	if card.type == TileType.WALL && card.wall_flags.max() == 5:
		describe = "The best walls on the market."
	else:
		describe = descriptions[card.type].format(card)
	if card.ac > 2:
		describe += " Requires an action surge to play."
	return describe
	
static func flavor_text_card(card):
	if card.type == TileType.WALL && card.wall_flags.max() == 5:
		return "The ultimate defense."
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

var world_env
var current_path = "res://menu.tscn"

# Game State
var level = 0
var turns = 0
var max_turns = 0
var actions = 2
var actions_per_turn = 2
var earned_treasure = false
var earned_treasure_index = 0
var beat = false

var block_interaction = false

var money = 0
var money_at_start = 0
var is_turn = false
var skip_to_inventory = false
var block_pause = false

func money_for_level():
	return min(35, 10 + 5 * (level))
	
func on_reset():
	earned_treasure_index = 0
	block_pause = false
	earned_treasure = false
	block_interaction = false
	is_turn = false
	turns = float(levels[level].turns)
	actions = actions_per_turn
	max_turns = turns
	money_at_start = money
	
func on_hard_reset():
	earned_treasure_index = 0
	Game.level = 0
	money = 0
	on_reset()
	
func reset_money():
	money = money_at_start

func on_you_win():
	block_pause = true
	
func _ready():
	self.connect("reset", self, "on_reset")
	self.connect("end_turn", self, "on_end_turn")
	self.connect("start_new_turn", self, "on_start_new_turn")
	self.connect("hard_reset", self, "on_hard_reset")
	self.connect("you_win", self, "on_you_win")
	on_reset()

func on_start_new_turn():
	for monster in get_tree().get_nodes_in_group("monsters"):
		monster.update_navigation()
	is_turn = true
	
func on_end_turn():
	is_turn = false
	
func get_board():
	return get_tree().root.find_node("Board", true, false)

func get_ui():
	return get_tree().root.find_node("UI", true, false)
	
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

signal highlight_friend(on)

signal foresight
signal foresight_end(card)

signal open_settings

signal hard_reset
