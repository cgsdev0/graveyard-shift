class_name PitTile
extends Tile
	
	
func _init(tile: Tile) -> void:
	self.tile_init(tile)
	
func _ready():
	color = Color.black
