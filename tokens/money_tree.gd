extends Spatial

var grid_x = 0
var grid_y = 0

var board

func _ready():
	board = Game.get_board()
	add_to_group("money_trees")
	add_to_group("killable_tokens")
	add_to_group("tokens")
	global_translation = board.get_tile(grid_x, grid_y).get_center()
	
func get_id():
	return grid_y * board.cols + grid_x
	
func tick():
	Game.money += 1

func kill():
	remove_from_group("money_trees")
	remove_from_group("killable_tokens")
	remove_from_group("tokens")
	queue_free()
