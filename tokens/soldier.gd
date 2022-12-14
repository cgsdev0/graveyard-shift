extends Pathfinder


func _ready():
	add_to_group("soldiers")	
	astar = MyAStar.new(board)
	update_navigation()

	
func get_action_limit():
	return 1
	
func _process(delta):
	if !enabled:
		queue_free()
		
func take_step():
	if !enabled:
		return
	var lures = get_tree().get_nodes_in_group("lures")
	for lure in lures:
		if lure.grid_x == grid_x && lure.grid_y == grid_y:
			lure.remove_from_group("lures")
			lure.eat()
			path = astar.get_id_path(grid_y * board.cols + grid_x, self.get_target_tile())
			return
	if path.size() <= 1 || get_path_cost(path) > 100:
		return
	var u = path[0]
	var v = path[1]
	grid_y = int(v / board.cols)
	grid_x = int(v % board.cols)
	movement_tween.interpolate_property(self, "global_translation",
	global_translation, board.get_tile(grid_x, grid_y).get_center(), 1,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	movement_tween.start()
	path = astar.get_id_path(grid_y * board.cols + grid_x, self.get_target_tile())

func get_target_tile():
	var lures = get_tree().get_nodes_in_group("lures")
	var cheapest_cost = 9999
	var cheapest_lure = null
	for lure in lures:
		var lure_id = lure.grid_y * board.cols + lure.grid_x
		var path = astar.get_id_path(grid_y * board.cols + grid_x, lure_id)
		var cost = get_path_cost(path)
		if cost < cheapest_cost:
			cheapest_lure = lure_id
			cheapest_cost = cost
	if cheapest_lure != null:
		return cheapest_lure
	return grid_y * board.cols + grid_x
	
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
				cost += 9999
			if v_wall && board.get_tile_by_id(v).check_wall_bit(i_dir):
				cost += 9999
		return cost

	func _estimate_cost(u, v):
		return _compute_cost(u, v)
