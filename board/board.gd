class_name Board
extends Spatial

var tile = preload("res://board/tile.tscn")

export var rows = 3
export var cols = 3

export var spacing = 0.0
export var size = Vector2(1.98, 1.98)
export var tile_height = 0.2

var actions = 1
var actions_per_turn = 1

func start_new_turn():
	actions = actions_per_turn
	
func place_card_on_tile(card, id: int) -> void:
	if actions <= 0 || card == null:
		return
	actions -= 1
	
	var desired_type = card.type
	var desired_flags = card.wall_flags
	
	match desired_type:
		Game.TileType.WALL, Game.TileType.SECRET_DOOR, Game.TileType.BRIDGE:
			get_child(id).wall_flags = desired_flags
		Game.TileType.LURE:
			var lure = preload("res://tokens/lure.tscn").instance()
			lure.grid_y = int(id / cols)
			lure.grid_x = int(id % cols)
			get_parent().add_child(lure)
			_propagate_board_change()
			return
		Game.TileType.SOLDIER:
			var soldier = load("res://tokens/soldier.tscn").instance()
			soldier.grid_y = int(id / cols)
			soldier.grid_x = int(id % cols)
			get_parent().add_child(soldier)
			_propagate_board_change()
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
	if get_tile_by_id(id).wall_flags == [0, 0, 0, 0]:
		replace_tile_by_id(id, Game.TileType.EMPTY)
		for tile in get_tree().get_nodes_in_group("placed_tiles"):
			if tile.placed_at == id:
				tile.queue_free()
				break
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
			t.init(Vector3(tile_size), Vector3(c * (width + spacing), 0, r * (height + spacing)), spacing)
			self.add_child(t)
	

	for tile in level.tiles:
		self.callv("replace_tile", tile)
		
	if find_tile_id(Game.TileType.TREASURE) != null:
		var exit = find_tile_id(Game.TileType.EXIT)
		spawn_adventurer(int(exit % cols), int(exit / cols))
	
	for monster in level.monsters:
		self.callv("spawn_monster", monster)

func get_middle():
	var middle = Vector2((cols * size.x + ((cols - 1) * spacing)) / 2, (rows * size.y + ((rows - 1) * spacing)) / 2)
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

func _process(delta):
	pass
	# update()
	
#func _draw():
	#draw_rect(Rect2(Vector2.ZERO, size), Color.red, false)
