extends Node


func _ready():
	$Control/Play.connect("on_click", self, "play")
	$Control/Settings.connect("on_click", self, "settings")
	$Control/Credits.connect("on_click", self, "credits")
	$Control/Exit.connect("on_click", self, "exit")
	
	$Sky2.material.set_shader_param("time_offset", OS.get_ticks_msec() / 1000.0)
	$Fog.material.set_shader_param("time_offset", OS.get_ticks_msec() / 1000.0 + 1)
	
func play():
	Game.emit_signal("change_scene", "res://main.tscn")
	
func settings():
	yield(get_tree().create_timer(0.0), "timeout")
	Game.emit_signal("open_settings")
	
func credits():
	Game.emit_signal("change_scene", "res://credits.tscn")
	
func exit():
	get_tree().quit()
