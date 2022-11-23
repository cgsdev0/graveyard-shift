extends AnimationPlayer


func _ready():
	play("RESET")
	Game.connect("you_win", self, "on_win")

func on_win():
	self.play("daytime")
	yield(self, "animation_finished")
	Game.emit_signal("daylight_animation_done")
