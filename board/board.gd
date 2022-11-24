class_name Board
extends Spatial

var tile = preload("res://board/tile.tscn")
var FencePost = preload("res://models/fence/fencePost.tscn")
var Fence = preload("res://models/fence/fence.tscn")
var Lantern = preload("res://models/lamp_post.tscn")

export var rows = 3
export var cols = 3

export var spacing = 0.0
export var size = Vector2(1.98, 1.98)
export var tile_height = 0.2

func has_actions():
	return Game.actions > 0
	
func start_new_turn():
	Game.actions = Game.actions_per_turn
	
func place_card_on_tile(card, id: int) -> void:
	if Game.actions <= 0 || card == null:
		return
	Game.actions -= card.ac
	
	var desired_type = card.type
	var desired_flags = card.wall_flags
	
	match desired_type:
		Game.TileType.WALL, Game.TileType.SECRET_DOOR, Game.TileType.BRIDGE:
			get_child(id).wall_flags = desired_flags
		Game.TileType.LURE:
			var lure = preload("res://tokens/lure.tscn").instance()
			lure.grid_y = int(id / cols)
			lure.grid_x = int(id % cols)
			if typeof(card.card.range) == TYPE_STRING:
				lure.lure_range = 1000
			else:
				lure.lure_range = card.card.range
			get_parent().add_child(lure)
			_propagate_board_change()
			return
		Game.TileType.MONEY_TREE:
			var money_tree = load("res://tokens/money_tree.tscn").instance()
			money_tree.grid_y = int(id / cols)
			money_tree.grid_x = int(id % cols)
			get_parent().add_child(money_tree)
			_propagate_board_change()
			return
		Game.TileType.COURAGE:
			for adventurer in get_tree().get_nodes_in_group("adventurers"):
				if adventurer.get_id() != id:
					continue
				adventurer.give_courage(card.card.courage)
			return
		Game.TileType.GUST:
			for pathfinder in get_tree().get_nodes_in_group("pathfinders"):
				if pathfinder.get_id() != id:
					continue
				pathfinder.gust(Game.gust_direction(card.card.direction))
			return
	replace_tile_by_id(id, desired_type)

func find_tile_id(type):
	for i in rows * cols:
		if get_tile_by_id(i).type == type:
			return i
	return null
	
func get_tile(col: int, row: int) -> Tile:
	return get_child(row * cols + col) as Tile
	
func get_tile_by_id(id: int) -> Tile:
	return get_child(id) as Tile

func compute_direction(u, v):
	var row_u = int(u / cols)
	var col_u = int(u % cols)
	var row_v = int(v / cols)
	var col_v = int(v % cols)
	if col_u == col_v:
		if row_v > row_u:
			return Game.Direction.SOUTH
		else:
			return Game.Direction.NORTH
	else:
		if col_v > col_u:
			return Game.Direction.EAST
		else:
			return Game.Direction.WEST
			
func _propagate_board_change():
	get_tree().call_group("pathfinders", "update_navigation")
	
func _replace_tile(exit_tile: Tile, type) -> void:
	exit_tile.type = type
	_propagate_board_change()
	
func replace_tile(col: int, row: int, type) -> void:
	_replace_tile(get_tile(col, row), type)

func replace_tile_by_id(id: int, type) -> void:
	_replace_tile(get_tile_by_id(id), type)

func damage_tile_wall_bit(id: int, direction) -> void:
	set_tile_wall_bit(id, direction, get_tile_by_id(id).wall_flags[direction] - 1)
	
func set_tile_wall_bit(id: int, direction, health: int) -> void:
	get_tile_by_id(id).wall_flags[direction] = max(0, health)
	for tile in get_tree().get_nodes_in_group("placed_tiles"):
		if tile.placed_at == id:
			tile.recompute_wall_decals()
	if get_tile_by_id(id).wall_flags == [0, 0, 0, 0]:
		replace_tile_by_id(id, Game.TileType.EMPTY)
		get_tile_by_id(id).stacks += 1
#		for tile in get_tree().get_nodes_in_group("placed_tiles"):
#			if tile.placed_at == id:
#				tile.queue_free()
#				break
	_propagate_board_change()
	
func _ready():
	Game.connect("start_new_turn", self, "start_new_turn")
	
	var level = Game.levels[Game.level]
	
	rows = level.rows
	cols = level.cols
	
	var width = size.x
	var height = size.y
	

	
	var tile_size = Vector3(width, tile_height, height)
	
	for r in rows:
		for c in cols:
			var t = tile.instance()
			var pos = Vector3(c * (width + spacing), 0, r * (height + spacing))
			t.init(Vector3(tile_size), pos, spacing)
			self.add_child(t)
			t.set_owner(self.get_owner())
			spawn_fence_post(r, c, pos, tile_size)
			spawn_fence(r, c, pos, tile_size)
			spawn_lantern(r, c, pos, tile_size)

	

	for tile in level.tiles:
		self.callv("replace_tile", tile)
		
	if find_tile_id(Game.TileType.TREASURE) != null:
		var exit = find_tile_id(Game.TileType.EXIT)
		spawn_adventurer(int(exit % cols), int(exit / cols))
	
	for monster in level.monsters:
		self.callv("spawn_monster", monster)

var fence_gap = 1.0
var height = -0.13

const lantern_math = [
	[],
	[],
	[1],
	[1, 2],
	[1, 3],
	[1, 4],
	[1, 3, 5]
]

func spawn_lantern(r, c, pos, tile_size):
	if not r in lantern_math[rows]:
		return
	if not c in lantern_math[cols]:
		return
	var f = Lantern.instance()
	call_deferred("add_to_parent", f)
	f.global_translation = pos - Vector3(spacing / 2, height, spacing / 2)
	
func spawn_fence(r, c, pos, tile_size):
	if r == 0:
		var f = Fence.instance()
		call_deferred("add_to_parent", f)
		f.global_translation = pos - Vector3(spacing / 2, height, fence_gap)
		if c == cols - 1:
			f = Fence.instance()
			call_deferred("add_to_parent", f)
			f.global_translation = pos - Vector3(-tile_size.x, height, fence_gap)
	if c == 0:
		var f = Fence.instance()
		call_deferred("add_to_parent", f)
		f.global_translation = pos - Vector3(fence_gap, height, 0 if r == 0 else spacing / 2)
		f.rotate_y(PI / 2)
	if c == cols - 1:
		var f = Fence.instance()
		call_deferred("add_to_parent", f)
		f.global_translation = pos + Vector3(tile_size. x + fence_gap, height, 0 if r == 0 else - spacing / 2)
		f.rotate_y(PI / 2)
	
func spawn_fence_post(r, c, pos, tile_size):
	if r == 0:
		var f = FencePost.instance()
		call_deferred("add_to_parent", f)
		f.global_translation = pos + Vector3(tile_size.x / 2, height, -fence_gap)
		if c == 0:
			f = FencePost.instance()
			call_deferred("add_to_parent", f)
			f.global_translation = pos + Vector3(-fence_gap, height, -fence_gap)
		if c == cols - 1:
			f = FencePost.instance()
			call_deferred("add_to_parent", f)
			f.global_translation = pos + Vector3(tile_size.x + fence_gap, height, -fence_gap)
	if c == 0:
		var f = FencePost.instance()
		call_deferred("add_to_parent", f)
		f.global_translation = pos + Vector3(-fence_gap, height, tile_size.z / 2)
	if c == cols - 1:
		var f = FencePost.instance()
		call_deferred("add_to_parent", f)
		f.global_translation = pos + Vector3(tile_size.x + fence_gap, height, tile_size.z / 2)

func add_to_parent(f):
	get_parent().add_child(f)
	
func get_middle():
	var middle = Vector3((cols * size.x + ((cols - 1) * spacing)) / 2, 0, (rows * size.y + ((rows - 1) * spacing)) / 2)
	return middle
	
func spawn_adventurer(x, y):
	var adventurer = load("res://tokens/adventurer.tscn").instance()
	adventurer.grid_x = x
	adventurer.grid_y = y
	get_parent().call_deferred("add_child", adventurer)
	
func spawn_monster(x, y, monster_type):
	var monster
	match monster_type:
		Game.MonsterType.SPRINTER:
			monster = load("res://tokens/monsters/sprinter.tscn").instance()
		Game.MonsterType.WALKER:
			monster = load("res://tokens/monsters/walker.tscn").instance()
	monster.grid_x = x
	monster.grid_y = y
	get_parent().call_deferred("add_child", monster)
	
func gap_from_direction(dir):
	match dir:
		Game.Direction.EAST:
			return 1
		Game.Direction.WEST:
			return -1
		Game.Direction.NORTH:
			return -cols
		Game.Direction.SOUTH:
			return cols

func compute_tile_id(start_id, dir):
	match dir:
		Game.Direction.EAST:
			if (start_id + 1) % cols == 0:
				return -1
			return start_id + 1
		Game.Direction.WEST:
			if start_id % cols == 0:
				return -1
			return start_id - 1
		Game.Direction.NORTH:
			if start_id / cols == 0:
				return -1
			return start_id - cols
		Game.Direction.SOUTH:
			if start_id / cols == rows - 1:
				return -1
			return start_id + cols
			
func is_on_board(id):
	return id <= rows * cols - 1 && id >= 0
	
func _process(delta):
	pass
	# update()
	
#func _draw():
	#draw_rect(Rect2(Vector2.ZERO, size), Color.red, false)
