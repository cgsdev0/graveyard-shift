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
	
	# Position debug objects
	$DebugCube.translation = size / 2
	$DebugCube.width = size.x
	$DebugCube.height = size.y
	$DebugCube.depth = size.z
	
	$DebugWall_NORTH.translation = size / 2 + Vector3(0, size.y, - 3 * size.z / 8)
	$DebugWall_NORTH.width = size.x * 0.98
	$DebugWall_NORTH.height = size.y
	$DebugWall_NORTH.depth = size.z / 4
	
	$DebugWall_SOUTH.translation = size / 2 + Vector3(0, size.y, 3 * size.z / 8)
	$DebugWall_SOUTH.width = size.x * 0.98
	$DebugWall_SOUTH.height = size.y
	$DebugWall_SOUTH.depth = size.z / 4
	
	$DebugWall_EAST.translation = size / 2  + Vector3(3 * size.x / 8, size.y, 0)
	$DebugWall_EAST.width = size.x / 4
	$DebugWall_EAST.height = size.y
	$DebugWall_EAST.depth = size.z * 0.98
	
	$DebugWall_WEST.translation = size / 2  + Vector3(-3 * size.x / 8, size.y, 0)
	$DebugWall_WEST.width = size.x /4 
	$DebugWall_WEST.height = size.y
	$DebugWall_WEST.depth = size.z * 0.98
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
	$DebugWall_NORTH.visible = check_wall_bit(Game.Direction.NORTH)
	$DebugWall_SOUTH.visible = check_wall_bit(Game.Direction.SOUTH)
	$DebugWall_EAST.visible = check_wall_bit(Game.Direction.EAST)
	$DebugWall_WEST.visible = check_wall_bit(Game.Direction.WEST)

func check_wall_bit(flag):
	return wall_flags & (1 << flag)

func _on_Tile_input_event(camera, event, position, normal, shape_idx):
	if type != Game.TileType.EMPTY && type != Game.TileType.WALL:
		return
	if event is InputEventMouseButton && event.pressed && event.button_index == 1:
		get_parent().place_card_on_tile(get_index())
	#	get_parent().replace_tile_by_id(get_index(), type + 1)
	if event is InputEventMouseButton && event.pressed && event.button_index == 2:
		get_parent().replace_tile_by_id(get_index(), Game.TileType.WALL)
		
		var offset = position - global_translation
#		var offset = event.global_position - global_position
		if offset.x < size.x / 4:
			get_parent().toggle_tile_wall_bit(get_index(), Game.Direction.WEST)
		if offset.x > 3 * size.x / 4:
			get_parent().toggle_tile_wall_bit(get_index(), Game.Direction.EAST)
		if offset.z < size.z / 4:
			get_parent().toggle_tile_wall_bit(get_index(), Game.Direction.NORTH)
		if offset.z > 3 * size.z / 4:
			get_parent().toggle_tile_wall_bit(get_index(), Game.Direction.SOUTH)
