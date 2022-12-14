extends Pathfinder

export var actions_economy = 2
export var move_speed = 0.4
export var monster_name = "Snake"
export var description = "Heads towards the exit,\nattacking things in the way."

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
	
var my_cost = null
func update_navigation():
	.update_navigation()
	
	var cost = get_path_cost(path)
	print(cost)
	if my_cost == null:
		my_cost = cost
	else:
		if my_cost == cost && Game.level == 0 && Game.is_turn:
			# oops
			Tutorial.trigger_line(Tutorial.Line.OOPS)
		my_cost = cost
	
func get_action_limit():
	return actions_economy
	
func get_name():
	return monster_name
	
func get_description():
	return description
	
func take_step():
	var soldiers = get_tree().get_nodes_in_group("killable_tokens")
	for soldier in soldiers:
		if is_my_neighbor(soldier):
			if check_wall(get_id(), soldier.get_id()):
				continue
			var attack_dir = board.compute_direction(get_id(), soldier.get_id())
			var y = rotate_to(attack_dir, true)
			if y is Object:
				yield(y, "completed")
			$AnimationPlayer.play("attack")
			yield($AnimationPlayer, "animation_finished")
			soldier.kill()
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
		var attack_dir = dir
		var y = rotate_to(attack_dir, true)
		if y is Object:
			yield(y, "completed")
		if board.get_tile_by_id(u).check_wall_bit(dir) == 1:
			board.get_parent().play_wall_break_sound()
		$AnimationPlayer.play("attack")
		yield($AnimationPlayer, "animation_finished")
		board.damage_tile_wall_bit(u, dir)
	elif v_wall && board.get_tile_by_id(v).check_wall_bit(i_dir):
		var attack_dir = dir
		var y = rotate_to(attack_dir, true)
		if y is Object:
			yield(y, "completed")
		if board.get_tile_by_id(v).check_wall_bit(i_dir) == 1:
			board.get_parent().play_wall_break_sound()
		$AnimationPlayer.play("attack")
		yield($AnimationPlayer, "animation_finished")
		board.damage_tile_wall_bit(v, i_dir)
	else:
		board.unmove_tokens_out_of_my_way(u)
		board.move_tokens_out_of_my_way(v)
		grid_y = int(v / board.cols)
		grid_x = int(v % board.cols)

		#global_translation = board.get_tile(grid_x, grid_y).get_center()
		movement_tween.interpolate_property(self, "global_translation",
		global_translation, board.get_tile(grid_x, grid_y).get_center(), move_speed,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		var y = rotate_to(dir, true)
		if y is Object:
			yield(y, "completed")
		$AnimationPlayer.play("move")
		movement_tween.start()
		moved()
		path = astar.get_id_path(grid_y * board.cols + grid_x, self.get_target_tile())
		yield(movement_tween, "tween_completed")
		if board.get_tile_by_id(v).spikes_ready:
			stunned = true
			skipped_turns += 1
			board.activate_spikes(v)
		elif board.get_tile_by_id(v).type == Game.TileType.SPIKES:
			board.misfire_spikes()
		var lures = get_tree().get_nodes_in_group("lures")
		for lure in lures:
			if lure.grid_x == grid_x && lure.grid_y == grid_y:
				lure.remove_from_group("lures")
				lure.eat()
				fixation = null
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
