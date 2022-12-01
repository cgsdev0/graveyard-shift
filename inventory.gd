extends Node

var controller

var _on_SkipButton_pressed_dead = false
func _on_SkipButton_pressed():
	if _on_SkipButton_pressed_dead:
		return
	_on_SkipButton_pressed_dead = true
	$DigSound.play()
	Game.emit_signal("reset")
	Game.emit_signal("change_scene", "res://main.tscn")

func fade_in():
	$AnimationPlayer.play("fade_in")
