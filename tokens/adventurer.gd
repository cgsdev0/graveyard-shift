extends Pathfinder

var has_treasure = false

func _ready():
	add_to_group("adventurers")
	add_to_group("killable_tokens")
	astar = MyAStar.new(board)
	update_navigation()
	Game.connect("start_new_turn", self, "reset_action_limit")
	reset_action_limit()
	

var action_limit
func reset_action_limit():
	action_limit = 2
	
func get_action_limit():
	return action_limit
	
func give_courage(v):
	action_limit += v
	
func _process(delta):
	if !enabled:
		queue_free()
		
func take_step():
	if !enabled:
		return
	var treasure_tile = board.find_tile_id(Game.TileType.TREASURE)
	if treasure_tile != null && treasure_tile == get_id():
		board.replace_tile_by_id(get_id(), Game.TileType.TREASURE_TAKEN)
		has_treasure = true
		return
	if path.size() <= 1 || get_path_cost(path) > 100:
		return
	var u = path[0]
	var v = path[1]
	grid_y = int(v / board.cols)
	grid_x = int(v % board.cols)
	movement_tween.interpolate_property(self, "global_translation",
	global_translation, board.get_tile(grid_x, grid_y).get_center(), 0.5,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	movement_tween.start()
	yield(movement_tween, "tween_completed")
	if board.get_tile_by_id(v).type == Game.TileType.EXIT:
		# rip adventurer
		var prize = ShopDeck.deal_treasure()
		Deck.pending_treasure_card = prize
		self.kill()
	path = astar.get_id_path(grid_y * board.cols + grid_x, self.get_target_tile())

func get_target_tile():
	var treasure = board.find_tile_id(Game.TileType.TREASURE)
	if treasure == null:
		return board.find_tile_id(Game.TileType.EXIT)
	return treasure
	
class MyAStar:
	extends AStar2D

	var board: Board
	func _init(board: Board):
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
				cost += 9999
			if v_wall && board.get_tile_by_id(v).check_wall_bit(i_dir):
				cost += 9999
		return cost

	func _estimate_cost(u, v):
		return _compute_cost(u, v)
