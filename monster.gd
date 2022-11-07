extends Pathfinder

func _ready():
	add_to_group("monsters")
	astar = MyAStar.new(board)
	update_navigation()
	
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
	return board.find_tile_id(Game.TileType.EXIT)
	
func take_step():

	var soldiers = get_tree().get_nodes_in_group("soldiers")
	for soldier in soldiers:
		if is_my_neighbor(soldier):
			soldier.queue_free()
			return
	var lures = get_tree().get_nodes_in_group("lures")
	for lure in lures:
		if lure.grid_x == grid_x && lure.grid_y == grid_y:
			lure.remove_from_group("lures")
			lure.queue_free()
			path = astar.get_id_path(grid_y * board.cols + grid_x, self.get_target_tile())
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
		global_translation = board.get_tile(grid_x, grid_y).get_center()
		path = astar.get_id_path(grid_y * board.cols + grid_x, self.get_target_tile())
#	update()

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
