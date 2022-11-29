extends Pathfinder

func _ready():
	add_to_group("monsters")
	astar = MyAStar.new(board)
	update_navigation()
	$AnimationPlayer.play("idle")

var fixation = null
func get_target_tile():
	if fixation != null:
		if !is_instance_valid(fixation):
			fixation = null
		else:
			return fixation.get_id()
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
			cheapest_lure = lure
			cheapest_cost = cost
	if cheapest_lure != null:
		fixation = cheapest_lure
		return fixation.get_id()
	return board.find_tile_id(Game.TileType.EXIT)[0]

func get_action_limit():
	return 2
	
func take_step():
	if path.size() <= 1 || get_path_cost(path) > 100:
		return
	var u = path[0]
	var v = path[1]
	var dir = board.compute_direction(u, v)
	var gap = board.gap_from_direction(dir)
	var u2 = u + gap
	var rolling = false

	while u != v:
		var attack_dir = _take_partial_step(u, u2, rolling, u == path[0], v == u2)
		if attack_dir != null:
			var y = rotate_to(attack_dir, true)
			if y is Object:
				yield(y, "completed")
			$AnimationPlayer.play("attack")
			yield($AnimationPlayer, "animation_finished")
			kill_all()
			break
		var y = rotate_to(dir, true)
		if y is Object:
			yield(y, "completed")
		$AnimationPlayer.play("move")
		moved()
		movement_tween.start()
		yield(movement_tween, "tween_all_completed")
		
		var lures = get_tree().get_nodes_in_group("lures")
		for lure in lures:
			if lure.grid_x == grid_x && lure.grid_y == grid_y:
				lure.remove_from_group("lures")
				lure.queue_free()
				fixation = null
				path = astar.get_id_path(grid_y * board.cols + grid_x, self.get_target_tile())
		rolling = true
		u = u2
		u2 += gap
		if stunned:
			break
	
	if board.get_tile_by_id(v).type == Game.TileType.WALL:
		if board.get_tile_by_id(u).check_wall_bit(dir):
			board.damage_tile_wall_bit(u, dir)
	path = astar.get_id_path(grid_y * board.cols + grid_x, self.get_target_tile())

var kill_queue = []
var wall_queue = []
func kill_all():
	while !kill_queue.empty():
		var enemy = kill_queue.pop_back()
		enemy.kill()
	while !wall_queue.empty():
		board.callv("damage_tile_wall_bit", wall_queue.pop_back())
		
func _take_partial_step(u, v, rolling, first, last):
	if !rolling:
		var soldiers = get_tree().get_nodes_in_group("killable_tokens")
		for soldier in soldiers:
			if is_my_neighbor(soldier):
				if check_wall(get_id(), soldier.get_id()):
					continue
				kill_queue.push_back(soldier)
				return board.compute_direction(u, soldier.get_id())
	else:
		var soldiers = get_tree().get_nodes_in_group("killable_tokens")
		for soldier in soldiers:
			if soldier.get_id() == v:
				if check_wall(get_id(), soldier.get_id()):
					continue
				kill_queue.push_back(soldier)
				return board.compute_direction(u, v)
	var lures = get_tree().get_nodes_in_group("lures")
	for lure in lures:
		if lure.grid_x == grid_x && lure.grid_y == grid_y:
			kill_queue.push(lure)
			path = astar.get_id_path(grid_y * board.cols + grid_x, self.get_target_tile())
			return Game.Direction.EAST
	var dir = board.compute_direction(u, v)
	var i_dir = Game.invert_direction(dir)
	var u_type = board.get_tile_by_id(u).type
	var v_type = board.get_tile_by_id(v).type
	var u_wall = Game.is_wall(u_type)
	var v_wall = Game.is_wall(v_type)
	if u_wall && board.get_tile_by_id(u).check_wall_bit(dir):
		# board.damage_tile_wall_bit(u, dir)
		wall_queue.push_back([u, dir])
		return dir
	elif v_wall && board.get_tile_by_id(v).check_wall_bit(i_dir):
		# board.damage_tile_wall_bit(v, i_dir)
		wall_queue.push_back([v, i_dir])
		return dir
	else:
		board.unmove_tokens_out_of_my_way(u)
		board.move_tokens_out_of_my_way(v)
		grid_y = int(v / board.cols)
		grid_x = int(v % board.cols)
		if board.get_tile_by_id(v).spikes_ready:
			board.activate_spikes(v)
			stunned = true
			skipped_turns += 1
		#global_translation = board.get_tile(grid_x, grid_y).get_center()
		var ease_type = Tween.EASE_OUT
		if first && last:
			ease_type = Tween.EASE_IN_OUT
		elif first:
			ease_type = Tween.EASE_IN
		var dist = global_translation.distance_to(board.get_tile(grid_x, grid_y).get_center())
		movement_tween.interpolate_property(self, "global_translation",
		global_translation, board.get_tile(grid_x, grid_y).get_center(), 
		dist / 4 if first or last else dist / 6,
		Tween.TRANS_QUAD if first or last else Tween.TRANS_LINEAR, 
		ease_type)

#		movement_tween.interpolate_property(self, "global_translation:z",
#		global_translation.z, board.get_tile(grid_x, grid_y).get_center().z, dist / 4,
#		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
#		movement_tween.interpolate_property(self, "global_translation:y",
#		global_translation.y, global_translation.y + 0.3, dist / 8,
#		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
#		movement_tween.interpolate_property(self, "global_translation:y",
#		global_translation.y + 0.3, global_translation.y, dist / 8,
#		Tween.TRANS_QUAD, Tween.EASE_OUT, dist / 8)
		# yield(movement_tween, "tween_completed")
		return null


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
	# print("COST: ", get_path_cost(path))
	
class MyAStar:
	extends AStar2D

	var board
	func _init(board):
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
