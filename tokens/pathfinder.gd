class_name Pathfinder
extends Spatial

var board: Board
var astar: AStar2D
var path: PoolIntArray

export var debug_path: bool = false

export var grid_x = 0
export var grid_y = 0

var skipped_turns = 0

var enabled = true
func kill():
	self.enabled = false
	
var movement_tween
func _ready():
	movement_tween = Tween.new()
	self.add_child(movement_tween)
	add_to_group("pathfinders")
	add_to_group("tokens")
	board = get_parent().get_node("Board")
	global_translation = board.get_tile(grid_x, grid_y).get_center()
	# update_navigation()

func get_id():
	return grid_y * board.cols + grid_x
	
func is_my_neighbor(pathfinder):
	if abs(pathfinder.grid_x - grid_x) == 1 && pathfinder.grid_y == grid_y:
		return true
	if abs(pathfinder.grid_y - grid_y) == 1 && pathfinder.grid_x == grid_x:
		return true
	return false
	
func take_step():
	pass
	
var debug_path_node = null
func draw_debug_path():
	if debug_path && debug_path_node == null:
		debug_path_node = ImmediateGeometry.new()
		debug_path_node.material_override = SpatialMaterial.new()
		debug_path_node.material_override.vertex_color_use_as_albedo = true
		debug_path_node.material_override.flags_unshaded = true
		debug_path_node.material_override.flags_use_point_size  = true
		debug_path_node.material_override.params_point_size  = 20
		get_parent().add_child(debug_path_node)
	if debug_path:
		debug_path_node.clear()
		debug_path_node.begin(Mesh.PRIMITIVE_POINTS)
		debug_path_node.set_color(Color.red)
		for i in range(path.size()):
			if i + 1 >= path.size():
				continue
			var A = board.get_tile_by_id(path[i]).get_center()
			var B = board.get_tile_by_id(path[i + 1]).get_center()
			debug_path_node.add_vertex(A)
			debug_path_node.add_vertex(B)
		debug_path_node.end()
			
	
func get_action_limit():
	return 0
	
func _process(delta):
	draw_debug_path()
		
func get_path_cost(path):
	var prev = null
	var cost = 0
	for point in path:
		if prev != null:
			cost += astar._compute_cost(prev, point)
		prev = point
	return cost
	
func get_target_tile():
	 return board.find_tile_id(Game.TileType.EXIT)
	
func update_navigation():
	if astar.get_point_count() == 0:
		# initialize the grid
		for r in board.rows:
			for c in board.cols:
				var id = r * board.cols + c
				astar.add_point(id, Vector2(c, r))
		for r in board.rows:
			for c in board.cols:
				var id = r * board.cols + c
				if r < board.rows - 1:
					var connect_to = (r + 1) * board.cols + c
					astar.connect_points(id, connect_to)
				if c < board.cols - 1:
					var connect_to = (r) * board.cols + c + 1
					astar.connect_points(id, connect_to)
	for r in board.rows:
		for c in board.cols:
			var id = r * board.cols + c
			astar.set_point_disabled(id, board.get_tile_by_id(id).type == Game.TileType.PIT)
	path = astar.get_id_path(grid_y * board.cols + grid_x, self.get_target_tile())

#func draw_arrow(a: Vector2, b: Vector2, color: Color):
#	draw_line(a, b, color)
#	var tip_unit_vector = (b - a).normalized()
#	draw_line(b, b + tip_unit_vector.rotated(2.7) * 6, color)
#	draw_line(b, b + tip_unit_vector.rotated(-2.7) * 6, color)

#func _draw():
#	var prev = null
#	for point in path:
#		if prev != null:
#			draw_arrow(board.get_tile_by_id(prev).get_center() - position, board.get_tile_by_id(point).get_center() - position, Color.red)
#		prev = point
