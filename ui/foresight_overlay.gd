extends ColorRect


func _ready():
	Game.connect("foresight", self, "on_foresight")
	Game.connect("foresight_end", self, "on_foresight_end")

func on_foresight():
	$AnimationPlayer.play("fade_in")
	
func on_foresight_end(_a):
	$AnimationPlayer.play("fade_out")
