class_name Board
extends Node2D

var tile = preload("res://board/tile.tscn")

export var rows = 3
export var cols = 3

export var spacing = 8
export var size = Vector2(100, 100)

func get_tile(col: int, row: int) -> Tile:
	return get_child(row * cols + col) as Tile
	
func get_tile_by_id(id: int) -> Tile:
	return get_child(id) as Tile

func _replace_tile(exit_tile: Tile, type: Script) -> void:
	exit_tile.replace_by(type.new(exit_tile))
	exit_tile.queue_free()
	get_tree().call_group("monsters", "update_navigation")
	
func replace_tile(col: int, row: int, type: Script) -> void:
	_replace_tile(get_tile(col, row), type)

func replace_tile_by_id(id: int, type: Script) -> void:
	_replace_tile(get_tile_by_id(id), type)

func _ready():
	var width = (size.x - spacing * (cols - 1)) / cols
	var height = (size.y - spacing * (rows - 1)) / rows
	var tile_size = Vector2(width, height)
	for r in rows:
		for c in cols:
			var t = tile.instance()
			t.size = Vector2(tile_size)
			t.position = Vector2(c * (width + spacing), r * (height + spacing))
			self.add_child(t)
	
	replace_tile(4, 3, ExitTile)
	
	replace_tile(0, 3, PitTile)
	replace_tile(2, 2, PitTile)
	replace_tile(3, 1, PitTile)
	

func _process(delta):
	update()
	
func _draw():
	draw_rect(Rect2(Vector2.ZERO, size), Color.red, false)
