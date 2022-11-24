class_name Pathfinder
extends Token

var astar: AStar2D
var path: PoolIntArray

export var debug_path: bool = false

var skipped_turns = 0

var stunned = false

var enabled = true
func kill():
	self.enabled = false

func manhattan_distance(u, v):
	var ux = u % board.cols
	var uy = u / board.cols
	var vx = v % board.cols
	var vy = v / board.cols
	return abs(ux - vx) + abs(uy - vy)
	
func gust(dir):
	var dest = board.compute_tile_id(get_id(), dir)
	grid_y = int(dest / board.cols)
	grid_x = int(dest % board.cols)
	movement_tween.interpolate_property(self, "global_translation",
	global_translation, board.get_tile(grid_x, grid_y).get_center(), 0.3,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

	if board.get_tile_by_id(dest).type == Game.TileType.PIT:
		movement_tween.interpolate_property(self, "global_translation",
		board.get_tile(grid_x, grid_y).get_center(), 
		board.get_tile(grid_x, grid_y).get_center() - Vector3(0, 3, 0), 0.3,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.3)
		grid_y = start_y
		grid_x = start_x
		movement_tween.interpolate_property(self, "global_translation",
		board.get_tile(grid_x, grid_y).get_center() + Vector3(0, 3, 0), 
		board.get_tile(grid_x, grid_y).get_center(), 0.3,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.6)
	movement_tween.start()
	update_navigation()
		
var start_x
var start_y

func _ready():
	movement_tween = Tween.new()
	self.add_child(movement_tween)
	add_to_group("pathfinders")
	board = get_parent().get_node("Board")
	if board:
		global_translation = board.get_tile(grid_x, grid_y).get_center()
	start_x = grid_x
	start_y = grid_y
	# update_navigation()

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

func check_wall(u, v):
	var dir = board.compute_direction(u, v)
	var i_dir = Game.invert_direction(dir)
	var u_wall = Game.is_wall(board.get_tile_by_id(u).type)
	var v_wall = Game.is_wall(board.get_tile_by_id(v).type)
	if u_wall && board.get_tile_by_id(u).check_wall_bit(dir):
		return true
	elif v_wall && board.get_tile_by_id(v).check_wall_bit(i_dir):
		return true
	return false
	
func update_navigation():
	if !board:
		return
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
