extends Pathfinder

var has_treasure = false
var treasure_index = 0

func _ready():
	add_to_group("adventurers")
	add_to_group("killable_tokens")
	astar = MyAStar.new(board)
	update_navigation()
	Game.connect("start_new_turn", self, "reset_action_limit")
	reset_action_limit()
	$AnimationPlayer.play("idle")
	global_transform.basis = global_transform.rotated(Vector3.UP, PI).basis
	

var action_limit
var has_courage = false
func reset_action_limit():
	action_limit = get_base_action_limit()
	has_courage = false
	
func get_name():
	return "Adventurer"

func get_description():
	return "Retrieves the nearest treasure,\nthen heads for the exit."
	
func get_base_action_limit():
	return 2
	
func get_action_limit():
	return action_limit
	
func give_courage(v):
	action_limit += v
	has_courage = true
	
func _process(delta):
	if !enabled:
		queue_free()
		
func take_step():
	if !enabled:
		return
	var treasure_tiles = board.find_tile_id(Game.TileType.TREASURE)
	if !treasure_tiles.empty() && get_id() in treasure_tiles:
		treasure_index = board.get_tile_by_id(get_id()).treasure_index
		$TreasureSound.play()
		board.replace_tile_by_id(get_id(), Game.TileType.TREASURE_TAKEN, true)
		has_treasure = true
		return
	if path.size() <= 1 || get_path_cost(path) > 100:
		return
	var u = path[0]
	var v = path[1]
	
	var u_type = board.get_tile_by_id(u).type
	var v_type = board.get_tile_by_id(v).type
	var u_wall = u_type == Game.TileType.SECRET_DOOR
	var v_wall = v_type == Game.TileType.SECRET_DOOR
	
	var dir = board.compute_direction(u, v)
	var i_dir = Game.invert_direction(dir)
	var should_play = false
	if (u_wall && board.get_tile_by_id(u).check_wall_bit(dir)) || (v_wall && board.get_tile_by_id(v).check_wall_bit(i_dir)):
		should_play = true
				
		
	board.unmove_tokens_out_of_my_way(u)
	board.move_tokens_out_of_my_way(v)
	grid_y = int(v / board.cols)
	grid_x = int(v % board.cols)
	movement_tween.interpolate_property(self, "global_translation",
	global_translation, board.get_tile(grid_x, grid_y).get_center(), 0.5,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	var y = rotate_to(dir, true)
	if y is Object:
		yield(y, "completed")
	movement_tween.start()
	moved()
	if should_play:
		$SecretDoor.play()
	yield(movement_tween, "tween_completed")
	if board.get_tile_by_id(v).spikes_ready:
		stunned = true
		board.activate_spikes(v)
		skipped_turns += 1
	elif board.get_tile_by_id(v).type == Game.TileType.SPIKES:
			board.misfire_spikes()
	if board.get_tile_by_id(v).type == Game.TileType.EXIT && has_treasure:
		# rip adventurer
		Game.earned_treasure = true
		Game.earned_treasure_index = treasure_index
		$Teleport.play()
		self.kill()
	path = astar.get_id_path(grid_y * board.cols + grid_x, self.get_target_tile())

func kill():
	$Wilhelm.play()
	self.remove_from_group("adventurers")
	self.remove_from_group("killable_tokens")
	self.remove_from_group("tokens")
	self.remove_from_group("pathfinders")
	$AnimationPlayer.play("RESET")
	$AnimationPlayer.play("fall_over")
	# visible = false
	
func get_target_tile():
	var treasures = board.find_tile_id(Game.TileType.TREASURE)
	if has_treasure || treasures.empty():
		return board.find_tile_id(Game.TileType.EXIT)[0]
	var cheapest_cost = 9999
	var cheapest_treasure = null
	for treasure in treasures:
		var path = astar.get_id_path(get_id(), treasure)
		if path.empty():
			continue
		var cost = get_path_cost(path)
		if cost < cheapest_cost:
			cheapest_treasure = treasure
			cheapest_cost = cost
	if cheapest_treasure != null:
		return cheapest_treasure
	return board.find_tile_id(Game.TileType.EXIT)[0]
	
class MyAStar:
	extends AStar2D

	var board
	func _init(board):
		self.board = board
		
	func _compute_cost(u, v):
		var cost = 1
		var u_type = board.get_tile_by_id(u).type
		var v_type = board.get_tile_by_id(v).type
		var u_wall = u_type != Game.TileType.SECRET_DOOR && Game.is_wall(u_type)
		var v_wall = v_type != Game.TileType.SECRET_DOOR && Game.is_wall(v_type)
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
