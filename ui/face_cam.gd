extends Camera


func _ready():
	pass

func _process(delta):
	global_translation.x = $"%face".global_translation.x / 2.2
	print($"%face".global_translation)
