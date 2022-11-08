extends Spatial


func _ready():
	pass

class MyCustomSorter:
	static func sort_deterministic(a, b):
		if a.get_index() < b.get_index():
			return true
		return false
		
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		for i in 2:
			var pathfinders = get_tree().get_nodes_in_group("pathfinders")
			pathfinders.sort_custom(MyCustomSorter, "sort_deterministic")
			for pathfinder in pathfinders:
				pathfinder.take_step()
			yield(get_tree().create_timer(0.2), "timeout")
			for monster in get_tree().get_nodes_in_group("monsters"):
				if $Board.get_tile_by_id(monster.get_id()).type == Game.TileType.EXIT:
					Game.emit_signal("game_over")
					return
