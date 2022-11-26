extends Button

func _ready():
	self.connect("pressed", self, "on_press")
	Game.connect("start_new_turn", self, "start_new_turn")
	pass

var desired_disabled = true

func start_new_turn():
	desired_disabled = false
	
func _process(delta):
	if Game.block_interaction:
		disabled = true
	else:
		disabled = desired_disabled
	
func on_press():
	desired_disabled = true
	Game.emit_signal("end_turn")
