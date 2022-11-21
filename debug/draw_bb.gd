extends Node2D


var rects = []
func _ready():
	pass
	
func _process(delta):
	update()
	rects.clear()

func _draw():
	for rect in rects:
		draw_rect(rect, Color.red, false)
