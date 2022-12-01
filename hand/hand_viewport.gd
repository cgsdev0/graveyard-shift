extends ViewportContainer


func _ready():
	Game.connect("you_win", self, "hide_stuff")
	Game.connect("game_over", self, "hide_stuff")

func hide_stuff():
	self.visible = false
