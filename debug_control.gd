extends Control


export var color = Color.red

func _process(delta):
	update()
func _draw():
	draw_rect(Rect2(Vector2(0, 0), rect_size), color, false)
