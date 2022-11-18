extends ViewportContainer


func _ready():
	Game.connect("you_win", self, "on_win")

func on_win():
	self.visible = false
