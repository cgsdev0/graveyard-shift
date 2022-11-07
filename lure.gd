extends Sprite3D

var grid_x = 0
var grid_y = 0

func _ready():
	var board = get_parent().get_node("Board")
	add_to_group("lures")
	global_translation = board.get_tile(grid_x, grid_y).get_center()

