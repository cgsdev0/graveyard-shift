class_name Pathfinder
extends Spatial

var board: Board
var astar: AStar2D
var path: PoolIntArray

export var grid_x = 0
export var grid_y = 0

func _ready():
	add_to_group("pathfinders")
	board = get_parent().get_node("Board")
	global_translation = board.get_tile(grid_x, grid_y).get_center()
	# update_navigation()

func is_my_neighbor(pathfinder):
	if abs(pathfinder.grid_x - grid_x) == 1 && pathfinder.grid_y == grid_y:
		return true
	if abs(pathfinder.grid_y - grid_y) == 1 && pathfinder.grid_x == grid_x:
		return true
	return false
	
func take_step():
	pass
	
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		for i in 3:
			self.take_step()
			yield(get_tree().create_timer(0.2), "timeout")
		
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
	print("COST: ", get_path_cost(path))

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
