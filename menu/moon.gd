tool
extends Control


func _ready():
	update()
	
func _process(delta):
	update()

func _draw():
	print(rect_size.x / 2)
	var offset = Vector2(rect_size.x / 2, -rect_size.y / 2)
	draw_circle(Vector2(0,0), 40, Color.yellow * 5)
