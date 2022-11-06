class_name Board
extends Node2D

var tile = preload("res://board/tile.tscn")

export var rows = 3
export var cols = 3

export var spacing = 8
export var size = Vector2(100, 100)

func find_tile_id(type) -> int:
	for i in rows * cols:
		if get_tile_by_id(i).type == type:
			return i
	return -1
	
func get_tile(col: int, row: int) -> Tile:
	return get_child(row * cols + col) as Tile
	
func get_tile_by_id(id: int) -> Tile:
	return get_child(id) as Tile

func compute_direction(u, v):
	var row_u = floor(u / cols)
	var col_u = floor(u % cols)
	var row_v = floor(v / cols)
	var col_v = floor(v % cols)
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

func set_tile_wall_bit(id: int, direction, on: bool) -> void:
	if on:
		get_tile_by_id(id).wall_flags |= 1 << direction
	else:
		get_tile_by_id(id).wall_flags &= ~(1 << direction)
	_propagate_board_change()
	
func toggle_tile_wall_bit(id: int, direction) -> void:
	get_tile_by_id(id).wall_flags ^= 1 << direction
	_propagate_board_change()
	
func _ready():
	var width = (size.x - spacing * (cols - 1)) / cols
	var height = (size.y - spacing * (rows - 1)) / rows
	var tile_size = Vector2(width, height)
	for r in rows:
		for c in cols:
			var t = tile.instance()
			t.init(Vector2(tile_size), Vector2(c * (width + spacing), r * (height + spacing)))
			self.add_child(t)
	
	replace_tile(4, 3, Game.TileType.EXIT)
	replace_tile(2, 0, Game.TileType.TREASURE)
	
	replace_tile(0, 3, Game.TileType.PIT)
	replace_tile(2, 2, Game.TileType.PIT)
	replace_tile(3, 1, Game.TileType.PIT)
	

func _process(delta):
	update()
	
func _draw():
	draw_rect(Rect2(Vector2.ZERO, size), Color.red, false)
