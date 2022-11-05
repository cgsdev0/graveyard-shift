class_name Tile
extends Area2D


export var size = Vector2(100, 100)
var color: Color
	
func get_center() -> Vector2:
	return global_position + size / 2
	
func tile_init(tile: Tile) -> void:
	size = tile.size
	position = tile.position
	
func _ready():
	if $CollisionShape2D != null:
		$CollisionShape2D.shape.extents = size / 2
		$CollisionShape2D.position = size / 2

func _process(delta):
	update()

func _draw():
	draw_rect(Rect2(Vector2.ZERO, size), color)



