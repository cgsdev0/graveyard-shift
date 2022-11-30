extends Spatial


func _ready():
	Game.connect("end_turn", self, "on_end_turn")

class MyCustomSorter:
	static func sort_deterministic(a, b):
		if a.is_in_group("adventurers") && a.has_courage:
			return true
		if b.is_in_group("adventurers") && b.has_courage:
			return false
		if a.is_in_group("monsters") && !b.is_in_group("monsters"):
			return true
		if a.is_in_group("adventurers") && !b.is_in_group("monsters"):
			return true
		if a.get_index() < b.get_index():
			return true
		return false
		
func play_animation(node, anim):
	var ap = node.get_node("AnimationPlayer")
	if !ap:
		return
	ap.play(anim)
func on_end_turn():
	var pathfinders = get_tree().get_nodes_in_group("pathfinders")
	pathfinders.sort_custom(MyCustomSorter, "sort_deterministic")
	var stepped_finders = 0
	for pathfinder in pathfinders:
		if !is_instance_valid(pathfinder):
			continue
		if !pathfinder.is_in_group("pathfinders"):
			continue
		pathfinder.stunned = false
		if pathfinder.skipped_turns:
			pathfinder.skipped_turns -= 1
			continue
		pathfinder.update_navigation()
		for i in pathfinder.get_action_limit():
			var step = pathfinder.take_step()
			if step is GDScriptFunctionState:
				yield(step, "completed")
			stepped_finders += 1
			if !pathfinder.enabled:
				# rip
				break
			play_animation(pathfinder, "idle")
			if pathfinder.is_in_group("monsters"):
				if $Board.get_tile_by_id(pathfinder.get_id()).type == Game.TileType.EXIT:
					Game.emit_signal("game_over")
					pathfinder.reset_rotation_horizontal()
					return
			yield(get_tree().create_timer(0.2), "timeout")
			if pathfinder.stunned:
				break
		if pathfinder.is_in_group("monsters"):
			if $Board.get_tile_by_id(pathfinder.get_id()).type == Game.TileType.TRAP:
				$Board.replace_tile_by_id(pathfinder.get_id(), Game.TileType.TRAP_SPRUNG, true, "Trap (Sprung)")
				for tile in get_tree().get_nodes_in_group("placed_tiles"):
					if tile.placed_at == pathfinder.get_id():
						tile.become({ "type": Game.TileType.TRAP_SPRUNG })
				pathfinder.skipped_turns += 1
				pathfinder.stunned = true
		var rot = pathfinder.reset_rotation_horizontal()
		if rot is GDScriptFunctionState:
			yield(rot, "completed")
	for money_tree in get_tree().get_nodes_in_group("money_trees"):
		money_tree.tick()
	Game.emit_signal("prep_new_turn")

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
