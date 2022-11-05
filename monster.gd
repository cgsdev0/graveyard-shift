extends Sprite

var board: Board
var astar
var path: PoolIntArray

func _ready():
	add_to_group("monsters")
	board = get_parent().get_node("Board")
	global_position = board.get_tile(0, 0).get_center()
	astar = MyAStar.new()
	update_navigation()
	path = astar.get_id_path(0, 19)
	print(path)

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
			astar.set_point_disabled(id, board.get_tile_by_id(id) is PitTile)
	path = astar.get_id_path(0, 19)
	update()

func draw_arrow(a: Vector2, b: Vector2, color: Color):
	draw_line(a, b, color)
	var tip_unit_vector = (b - a).normalized()
	draw_line(b, b + tip_unit_vector.rotated(2.7) * 6, color)
	draw_line(b, b + tip_unit_vector.rotated(-2.7) * 6, color)

func _draw():
	var prev = null
	for point in path:
		if prev != null:
			draw_arrow(board.get_tile_by_id(prev).get_center() - position, board.get_tile_by_id(point).get_center() - position, Color.red)
		prev = point
class MyAStar:
	extends AStar2D

	func _compute_cost(u, v):
		return abs(u - v)

	func _estimate_cost(u, v):
		return _compute_cost(u, v)
