extends Button

func _ready():
	self.connect("pressed", self, "on_press")
	Game.connect("start_new_turn", self, "start_new_turn")
	pass

func start_new_turn():
	disabled = false
	
func on_press():
	disabled = true
	Game.emit_signal("end_turn")
