extends Node

var controller

func _on_SkipButton_pressed():
	$DigSound.play()
	Game.emit_signal("reset")
	Game.emit_signal("change_scene", "res://main.tscn")

func fade_in():
	$AnimationPlayer.play("fade_in")
