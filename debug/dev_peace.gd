extends AudioStreamPlayer


func _ready():
	if OS.is_debug_build():
		autoplay = false
		self.stop()
