extends Spatial


func _ready():
	Game.connect("end_turn", self, "on_end_turn")

class MyCustomSorter:
	static func sort_deterministic(a, b):
		if a.is_in_group("monsters") && !b.is_in_group("monsters"):
			return true
		if a.is_in_group("adventurers") && !b.is_in_group("monsters"):
			return true
		if a.get_index() < b.get_index():
			return true
		return false
		
func on_end_turn():
	var pathfinders = get_tree().get_nodes_in_group("pathfinders")
	pathfinders.sort_custom(MyCustomSorter, "sort_deterministic")
	var stepped_finders = 0
	for pathfinder in pathfinders:
		if !is_instance_valid(pathfinder):
			continue
		if pathfinder.skipped_turns:
			pathfinder.skipped_turns -= 1
			continue
		for i in pathfinder.get_action_limit():
			pathfinder.take_step()
			if pathfinder.movement_tween.is_active():
				yield(pathfinder.movement_tween, "tween_completed")
			stepped_finders += 1
			if pathfinder.is_in_group("monsters"):
				if $Board.get_tile_by_id(pathfinder.get_id()).type == Game.TileType.EXIT:
					Game.emit_signal("game_over")
					return
			yield(get_tree().create_timer(0.2), "timeout")
		if pathfinder.is_in_group("monsters"):
			if $Board.get_tile_by_id(pathfinder.get_id()).type == Game.TileType.TRAP:
				$Board.replace_tile_by_id(pathfinder.get_id(), Game.TileType.TRAP_SPRUNG)
				pathfinder.skipped_turns += 1
	Game.emit_signal("start_new_turn")

#	for i in 100:
#		var stepped_finders = 0
#		var pathfinders = get_tree().get_nodes_in_group("pathfinders")
#		pathfinders.sort_custom(MyCustomSorter, "sort_deterministic")
#		for pathfinder in pathfinders:
#			if !is_instance_valid(pathfinder):
#				continue
#			if pathfinder.get_action_limit() > i:
#				pathfinder.take_step()
#				if pathfinder.movement_tween.is_active():
#					yield(pathfinder.movement_tween, "tween_completed")
#				stepped_finders += 1
#
#		for monster in get_tree().get_nodes_in_group("monsters"):
#			if $Board.get_tile_by_id(monster.get_id()).type == Game.TileType.EXIT:
#				Game.emit_signal("game_over")
#				return
#		if stepped_finders == 0:
#			Game.emit_signal("start_new_turn")
#			return
#		yield(get_tree().create_timer(0.2), "timeout")
