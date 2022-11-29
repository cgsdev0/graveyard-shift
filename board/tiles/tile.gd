class_name Tile
extends Area


export var size = Vector3(100, 5, 100)
var spacing = 0.0
var color: Color = Color.white
var type = Game.TileType.EMPTY
var wall_flags = [0, 0, 0, 0]
var spikes_ready = false

var stacks = 0
var title

func get_title():
	if title:
		return title
	return Game.title_card(self)
	
func refresh_type():
	$TileMesh.become({ "type": self.type })
	
func get_center() -> Vector3:
	return global_translation + size / 2 + Vector3(0, 0.1 + 0.06 * stacks, 0)
	
func init(s: Vector3, t: Vector3, spacing: float) -> void:
	size = s
	translation = t
	self.spacing = spacing
	
func set_selection_glow(v):
	$TileMesh.set_selection_glow(v)
	
func set_selection_glow_color(v):
	$TileMesh.set_selection_glow_color(v)
	
func on_start_new_turn():
	if type == Game.TileType.SPIKES:
		spikes_ready = true
		
func on_board_ready():
	Game.connect("start_new_turn", self, "on_start_new_turn")
	$CollisionShape2D.shape.extents = size / 2 + Vector3(spacing / 2, 0, spacing / 2)
	$CollisionShape2D.translation = size / 2
	$TileMesh.translation = size / 2
	$TileMesh.attach_selection_glow()
	refresh_type()
	
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
#		Game.TileType.PIT:
#			color = Color.black
		Game.TileType.WALL, Game.TileType.BRIDGE:
			color = Color.white
			
func _process(delta):
	# TODO: PASS HERE
	set_color_from_type()
	$DebugCube.material.albedo_color = color
	if color != Color.white:
		$TileMesh.set_debug_tint(color)
#	$DebugWall_NORTH.visible = check_wall_bit(Game.Direction.NORTH)
#	$DebugWall_SOUTH.visible = check_wall_bit(Game.Direction.SOUTH)
#	$DebugWall_EAST.visible = check_wall_bit(Game.Direction.EAST)
#	$DebugWall_WEST.visible = check_wall_bit(Game.Direction.WEST)

func check_wall_bit(flag):
	return wall_flags[flag]
