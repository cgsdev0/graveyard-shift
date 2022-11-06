class_name Tile
extends Area2D


export var size = Vector2(100, 100)
var color: Color
var type = Game.TileType.EMPTY
var wall_flags = 0b0000
	
func get_center() -> Vector2:
	return global_position + size / 2
	
func init(s: Vector2, p: Vector2) -> void:
	size = s
	position = p
	
func _ready():
	$CollisionShape2D.shape.extents = size / 2
	$CollisionShape2D.position = size / 2
	set_color_from_type()

func set_color_from_type():
	match type:
		Game.TileType.EMPTY:
			color = Color.white
		Game.TileType.PIT:
			color = Color.black
		Game.TileType.WALL:
			color = Color.white
		Game.TileType.TREASURE:
			color = Color.gold
		Game.TileType.EXIT:
			color = Color.green
			
func _process(delta):
	set_color_from_type()
	update()

func check_wall_bit(flag):
	return wall_flags & (1 << flag)
	
func _draw():
	draw_rect(Rect2(Vector2.ZERO, size), color)
	if type == Game.TileType.WALL:
		if check_wall_bit(Game.Direction.WEST):
			draw_rect(Rect2(Vector2.ZERO, Vector2(size.x / 4, size.y)), Color.purple)
		if check_wall_bit(Game.Direction.EAST):
			draw_rect(Rect2(Vector2(size.x, 0), Vector2(- size.x / 4, size.y)), Color.purple)
		if check_wall_bit(Game.Direction.NORTH):
			draw_rect(Rect2(Vector2.ZERO, Vector2(size.x, size.y / 4)), Color.purple)
		if check_wall_bit(Game.Direction.SOUTH):
			draw_rect(Rect2(Vector2(0, size.y), Vector2(size.x, - size.y / 4)), Color.purple)


func _on_Tile_input_event(viewport, event, shape_idx):
	if type != Game.TileType.EMPTY && type != Game.TileType.WALL:
		return
	#if event is InputEventMouseButton && event.pressed && event.button_index == 1:
	#	get_parent().replace_tile_by_id(get_index(), type + 1)
	if event is InputEventMouseButton && event.pressed && event.button_index == 2:
		get_parent().replace_tile_by_id(get_index(), Game.TileType.WALL)
		var offset = event.global_position - global_position
		if offset.x < size.x / 4:
			get_parent().toggle_tile_wall_bit(get_index(), Game.Direction.WEST)
		if offset.x > 3 * size.x / 4:
			get_parent().toggle_tile_wall_bit(get_index(), Game.Direction.EAST)
		if offset.y < size.y / 4:
			get_parent().toggle_tile_wall_bit(get_index(), Game.Direction.NORTH)
		if offset.y > 3 * size.y / 4:
			get_parent().toggle_tile_wall_bit(get_index(), Game.Direction.SOUTH)
