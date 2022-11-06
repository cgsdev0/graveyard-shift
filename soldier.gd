extends Sprite

var board: Board
var astar
var path: PoolIntArray

var grid_x = 3
var grid_y = 0

func _ready():
	add_to_group("soldiers")
	add_to_group("pathfinders")
	board = get_parent().get_node("Board")
	global_position = board.get_tile(grid_x, grid_y).get_center()
	astar = MyAStar.new(board)
	update_navigation()

func take_step():
	return
	if path.size() <= 1:
		return
	var u = path[0]
	var v = path[1]
	var dir = board.compute_direction(u, v)
	var i_dir = Game.invert_direction(dir)
	var u_wall = board.get_tile_by_id(u).type == Game.TileType.WALL
	var v_wall = board.get_tile_by_id(v).type == Game.TileType.WALL
	if u_wall && board.get_tile_by_id(u).check_wall_bit(dir):
		board.set_tile_wall_bit(u, dir, false)
	elif v_wall && board.get_tile_by_id(v).check_wall_bit(i_dir):
		board.set_tile_wall_bit(v, i_dir, false)
	else:
		grid_y = floor(v / board.cols)
		grid_x = floor(v % board.cols)
		global_position = board.get_tile(grid_x, grid_y).get_center()
		path = astar.get_id_path(grid_y * board.cols + grid_x, board.find_tile_id(Game.TileType.EXIT))
	update()
	
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		for i in 3:
			take_step()
			yield(get_tree().create_timer(0.3), "timeout")
		
func get_path_cost(path):
	var prev = null
	var cost = 0
	for point in path:
		if prev != null:
			cost += astar._compute_cost(prev, point)
		prev = point
	return cost
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
	path = astar.get_id_path(grid_y * board.cols + grid_x, board.find_tile_id(Game.TileType.EXIT))
	print("COST: ", get_path_cost(path))
	update()

func draw_arrow(a: Vector2, b: Vector2, color: Color):
	draw_line(a, b, color)
	var tip_unit_vector = (b - a).normalized()
	draw_line(b, b + tip_unit_vector.rotated(2.7) * 6, color)
	draw_line(b, b + tip_unit_vector.rotated(-2.7) * 6, color)

func _draw():
	return
	var prev = null
	for point in path:
		if prev != null:
			draw_arrow(board.get_tile_by_id(prev).get_center() - position, board.get_tile_by_id(point).get_center() - position, Color.red)
		prev = point

class MyAStar:
	extends AStar2D

	var board: Board
	func _init(board: Board):
		self.board = board
		
	func _compute_cost(u, v):
		var cost = 1
		var u_wall = board.get_tile_by_id(u).type == Game.TileType.WALL
		var v_wall = board.get_tile_by_id(v).type == Game.TileType.WALL
		if  u_wall || v_wall:
			var dir = board.compute_direction(u, v)
			var i_dir = Game.invert_direction(dir)
			if u_wall && board.get_tile_by_id(u).check_wall_bit(dir):
				cost += 1
			if v_wall && board.get_tile_by_id(v).check_wall_bit(i_dir):
				cost += 1
		return cost

	func _estimate_cost(u, v):
		return _compute_cost(u, v)
