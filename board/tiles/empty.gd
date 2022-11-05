class_name EmptyTile
extends Tile
	
	
func _ready():
	color = Color.white

func _on_Tile_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		get_parent().replace_tile_by_id(get_index(), PitTile)
	pass # Replace with function body.
