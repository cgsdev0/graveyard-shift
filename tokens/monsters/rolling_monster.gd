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

func get_action_limit():
	return 2
	
func take_step():
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
	var gap = board.gap_from_direction(dir)
	var u2 = u + gap
	var rolling = false
	while u != v:
		if _take_partial_step(u, u2, rolling):
			break
		rolling = true
		u = u2
		u2 += gap
	
	if board.get_tile_by_id(v).type == Game.TileType.WALL:
		if board.get_tile_by_id(u).check_wall_bit(dir):
			if movement_tween.is_active():
					yield(movement_tween, "tween_completed")
			board.damage_tile_wall_bit(u, dir)
	path = astar.get_id_path(grid_y * board.cols + grid_x, self.get_target_tile())
	
func _take_partial_step(u, v, rolling):
	if !rolling:
		var soldiers = get_tree().get_nodes_in_group("soldiers")
		for soldier in soldiers:
			if is_my_neighbor(soldier):
				if check_wall(get_id(), soldier.get_id()):
					continue
				soldier.kill()
				return true
	else:
		var soldiers = get_tree().get_nodes_in_group("soldiers")
		for soldier in soldiers:
			if soldier.get_id() == v:
				if check_wall(get_id(), soldier.get_id()):
					continue
				if movement_tween.is_active():
					yield(movement_tween, "tween_completed")
				soldier.kill()
				return true
	var lures = get_tree().get_nodes_in_group("lures")
	for lure in lures:
		if lure.grid_x == grid_x && lure.grid_y == grid_y:
			lure.remove_from_group("lures")
			lure.queue_free()
			path = astar.get_id_path(grid_y * board.cols + grid_x, self.get_target_tile())
			return true
	var dir = board.compute_direction(u, v)
	var i_dir = Game.invert_direction(dir)
	var u_wall = board.get_tile_by_id(u).type == Game.TileType.WALL
	var v_wall = board.get_tile_by_id(v).type == Game.TileType.WALL
	if u_wall && board.get_tile_by_id(u).check_wall_bit(dir):
		if movement_tween.is_active():
			yield(movement_tween, "tween_completed")
		board.damage_tile_wall_bit(u, dir)
		return true
	elif v_wall && board.get_tile_by_id(v).check_wall_bit(i_dir):
		if movement_tween.is_active():
			yield(movement_tween, "tween_completed")
		board.damage_tile_wall_bit(v, i_dir)
		return true
	else:
		grid_y = int(v / board.cols)
		grid_x = int(v % board.cols)
		#global_translation = board.get_tile(grid_x, grid_y).get_center()
		movement_tween.interpolate_property(self, "global_translation",
		global_translation, board.get_tile(grid_x, grid_y).get_center(), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		movement_tween.start()
		return false


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
				for r2 in range(r + 1, board.rows):
					var connect_to = r2 * board.cols + c
					astar.connect_points(id, connect_to)
				for c2 in range(c + 1, board.cols):
					var connect_to = r * board.cols + c2
					astar.connect_points(id, connect_to)
	for r in board.rows:
		for c in board.cols:
			var id = r * board.cols + c
			astar.set_point_disabled(id, board.get_tile_by_id(id).type == Game.TileType.PIT)
	path = astar.get_id_path(grid_y * board.cols + grid_x, self.get_target_tile())
	print("COST: ", get_path_cost(path))
	
class MyAStar:
	extends AStar2D

	var board: Board
	func _init(board: Board):
		self.board = board
		
	func _compute_cost_neighbor(u, v):
		var cost = 0
		if board.get_tile_by_id(u).type == Game.TileType.PIT || board.get_tile_by_id(v).type == Game.TileType.PIT:
			return 999
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

	func _compute_cost(u, v):
		var ou = u
		if !self.are_points_connected(u, v):
			return 999
		var cost = 1
		var dir = board.compute_direction(u, v)
		var gap = board.gap_from_direction(dir)
		var u2 = u + gap
		while u != v:
			cost += _compute_cost_neighbor(u, u2)
			u = u2
			u2 += gap
		return cost
		
	func _estimate_cost(u, v):
		return 0 # IDK why but it works
