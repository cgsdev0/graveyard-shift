class_name Token
extends Spatial

var grid_x = 0
var grid_y = 0

var movement_tween
var turn_tween

var board

var initial_transform

var facing = Game.Direction.EAST

func reset_rotation_horizontal():
	match facing:
		Game.Direction.EAST, Game.Direction.WEST:
			return
	return rotate_to(Game.Direction.EAST)
	
func rotate_to(dir, force_cheat = false):
	var cheat = 0
	if grid_x * 2 > board.cols - 1 || force_cheat:
		cheat = PI / 8
	if grid_x * 2 < board.cols - 1:
		cheat = -PI / 8
	var basis
	facing = dir
	match dir:
		Game.Direction.NORTH:
			basis = initial_transform.rotated(Vector3.UP, PI / 2.0 - cheat).basis
		Game.Direction.SOUTH:
			basis = initial_transform.rotated(Vector3.UP, PI / 2.0 * 3.0 + cheat).basis
		Game.Direction.EAST:
			basis = initial_transform.basis
		Game.Direction.WEST:
			basis = initial_transform.rotated(Vector3.UP, PI).basis
	if basis == global_transform.basis:
		return
	turn_tween.interpolate_property(self, "global_transform:basis", global_transform.basis, basis, 0.4,
	Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	turn_tween.start()
	yield(turn_tween, "tween_completed")
	return
			
func _ready():
	turn_tween = Tween.new()
	self.add_child(turn_tween)
	initial_transform = global_transform
	board = Game.get_board()
	add_to_group("tokens")
	global_translation = board.get_tile(grid_x, grid_y).get_center()

func get_id():
	return grid_y * board.cols + grid_x
