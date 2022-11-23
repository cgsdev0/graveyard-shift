extends CanvasLayer

signal transitioned

func transition():
	$AnimationPlayer.play("fade_out")
	yield($AnimationPlayer, "animation_finished")
	self.emit_signal("transitioned")
	$AnimationPlayer.play("fade_in")
