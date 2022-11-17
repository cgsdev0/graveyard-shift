extends Node


func _process(delta):
	$BoardViewport.margin_left = -$UI/RightBar.rect_size.x
	pass
