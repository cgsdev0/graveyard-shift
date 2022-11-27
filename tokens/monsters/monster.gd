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
		if lure.lure_range < manhattan_distance(lure.get_id(), self.get_id()):
			continue
		var lure_id = lure.grid_y * board.cols + lure.grid_x
		var path = astar.get_id_path(grid_y * board.cols + grid_x, lure_id)
		var cost = get_path_cost(path)
		if cost < cheapest_cost:
			cheapest_lure = lure_id
			cheapest_cost = cost
	if cheapest_lure != null:
		return cheapest_lure
	return board.find_tile_id(Game.TileType.EXIT)[0]
	
func get_action_limit():
	return 2
	
func take_step():
	var soldiers = get_tree().get_nodes_in_group("killable_tokens")
	for soldier in soldiers:
		if is_my_neighbor(soldier):
			if check_wall(get_id(), soldier.get_id()):
				continue
			soldier.kill()
			return
	var lures = get_tree().get_nodes_in_group("lures")
	for lure in lures:
		if lure.grid_x == grid_x && lure.grid_y == grid_y:
			lure.remove_from_group("lures")
			lure.queue_free()
			path = astar.get_id_path(grid_y * board.cols + grid_x, self.get_target_tile())
			return
	if path.size() <= 1 || get_path_cost(path) > 100:
		return
	var u = path[0]
	var v = path[1]
	var dir = board.compute_direction(u, v)
	var i_dir = Game.invert_direction(dir)
	var u_type = board.get_tile_by_id(u).type
	var v_type = board.get_tile_by_id(v).type
	var u_wall = Game.is_wall(u_type)
	var v_wall = Game.is_wall(v_type)
	if u_wall && board.get_tile_by_id(u).check_wall_bit(dir):
		board.damage_tile_wall_bit(u, dir)
	elif v_wall && board.get_tile_by_id(v).check_wall_bit(i_dir):
		board.damage_tile_wall_bit(v, i_dir)
	else:
		grid_y = int(v / board.cols)
		grid_x = int(v % board.cols)
		if board.get_tile_by_id(v).spikes_ready:
			stunned = true
			skipped_turns += 1
		#global_translation = board.get_tile(grid_x, grid_y).get_center()
		movement_tween.interpolate_property(self, "global_translation",
		global_translation, board.get_tile(grid_x, grid_y).get_center(), 0.4,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		movement_tween.start()
		path = astar.get_id_path(grid_y * board.cols + grid_x, self.get_target_tile())
#	update()

class MyAStar:
	extends AStar2D

	var board
	func _init(board):
		self.board = board
		
	func _compute_cost(u, v):
		var cost = 1
		var u_type = board.get_tile_by_id(u).type
		var v_type = board.get_tile_by_id(v).type
		var u_wall = Game.is_wall(u_type)
		var v_wall = Game.is_wall(v_type)
		if  u_wall || v_wall:
			var dir = board.compute_direction(u, v)
			var i_dir = Game.invert_direction(dir)
			if u_wall && board.get_tile_by_id(u).check_wall_bit(dir):
				cost += board.get_tile_by_id(u).check_wall_bit(dir)
			if v_wall && board.get_tile_by_id(v).check_wall_bit(i_dir):
				cost += board.get_tile_by_id(v).check_wall_bit(i_dir)
		return cost

	func _estimate_cost(u, v):
		return 0 # IDK why but it works
