class_name Tile
extends Area


export var size = Vector3(100, 5, 100)
var color: Color
var type = Game.TileType.EMPTY
var wall_flags = 0b0000
	
func get_center() -> Vector3:
	return global_translation + size / 2 + Vector3(0, 0.5, 0)
	
func init(s: Vector3, t: Vector3) -> void:
	size = s
	translation = t
	
func _ready():
	$CollisionShape2D.shape.extents = size / 2
	$CollisionShape2D.translation = size / 2
	$DebugCube.translation = size / 2
	$DebugCube.width = size.x
	$DebugCube.height = size.y
	$DebugCube.depth = size.z
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
	$DebugCube.material.albedo_color = color

func check_wall_bit(flag):
	return wall_flags & (1 << flag)
	
#func _draw():
#	draw_rect(Rect2(Vector2.ZERO, size), color)
#	if type == Game.TileType.WALL:
#		if check_wall_bit(Game.Direction.WEST):
#			draw_rect(Rect2(Vector2.ZERO, Vector2(size.x / 4, size.y)), Color.purple)
#		if check_wall_bit(Game.Direction.EAST):
#			draw_rect(Rect2(Vector2(size.x, 0), Vector2(- size.x / 4, size.y)), Color.purple)
#		if check_wall_bit(Game.Direction.NORTH):
#			draw_rect(Rect2(Vector2.ZERO, Vector2(size.x, size.y / 4)), Color.purple)
#		if check_wall_bit(Game.Direction.SOUTH):
#			draw_rect(Rect2(Vector2(0, size.y), Vector2(size.x, - size.y / 4)), Color.purple)


func _on_Tile_input_event(camera, event, position, normal, shape_idx):
	if type != Game.TileType.EMPTY && type != Game.TileType.WALL:
		return
	if event is InputEventMouseButton && event.pressed && event.button_index == 1:
		if get_parent().card != null:
			var desired_type = get_parent().card.type
			get_parent().card.type = Game.TileType.EMPTY
			get_parent().card = null
			match desired_type:
				Game.TileType.WALL:
					get_parent().set_tile_wall_bit(get_index(), Game.Direction.NORTH, true)
				Game.TileType.LURE:
					var lure = preload("res://lure.tscn").instance()
					lure.grid_y = floor(get_index() / get_parent().cols)
					lure.grid_x = floor(get_index() % get_parent().cols)
					get_parent().get_parent().add_child(lure)
					get_parent()._propagate_board_change()
					return
				Game.TileType.SOLDIER:
					var soldier = load("res://soldier.tscn").instance()
					soldier.grid_y = floor(get_index() / get_parent().cols)
					soldier.grid_x = floor(get_index() % get_parent().cols)
					get_parent().get_parent().add_child(soldier)
					get_parent()._propagate_board_change()
					return
			get_parent().replace_tile_by_id(get_index(), desired_type)
	#	get_parent().replace_tile_by_id(get_index(), type + 1)
	if event is InputEventMouseButton && event.pressed && event.button_index == 2:
		get_parent().replace_tile_by_id(get_index(), Game.TileType.WALL)
#		var offset = event.global_position - global_position
#		if offset.x < size.x / 4:
#			get_parent().toggle_tile_wall_bit(get_index(), Game.Direction.WEST)
#		if offset.x > 3 * size.x / 4:
#			get_parent().toggle_tile_wall_bit(get_index(), Game.Direction.EAST)
#		if offset.y < size.y / 4:
#			get_parent().toggle_tile_wall_bit(get_index(), Game.Direction.NORTH)
#		if offset.y > 3 * size.y / 4:
#			get_parent().toggle_tile_wall_bit(get_index(), Game.Direction.SOUTH)
