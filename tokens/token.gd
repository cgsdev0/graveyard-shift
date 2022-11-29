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
	if self.is_in_group("adventurers"):
		return rotate_to(Game.Direction.WEST)
	return rotate_to(Game.Direction.EAST)
	
var moved_stack = 0
func moved():
	moved_stack = 0
	
func unmove_out_of_way():
	if moved_stack > 0:
		moved_stack -= 1
		movement_tween.interpolate_property(self, "global_translation", 
		global_translation,
		global_translation + Vector3(0.0, 0.0, -0.25), 
		0.2,
		Tween.TRANS_LINEAR, 
		Tween.EASE_IN,
		0.4)
		movement_tween.start()
		
func move_out_of_way():
	moved_stack += 1
	movement_tween.interpolate_property(self, "global_translation", 
	global_translation,
	global_translation + Vector3(0.0, 0.0, 0.25), 
	0.2,
	Tween.TRANS_LINEAR, 
	Tween.EASE_IN)
	movement_tween.start()

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
			basis = initial_transform.rotated(Vector3.UP, PI / 2.0 + cheat).basis
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
	movement_tween = Tween.new()
	self.add_child(movement_tween)
	turn_tween = Tween.new()
	self.add_child(turn_tween)
	initial_transform = global_transform
	board = Game.get_board()
	add_to_group("tokens")
	global_translation = board.get_tile(grid_x, grid_y).get_center()

func get_id():
	return grid_y * board.cols + grid_x
