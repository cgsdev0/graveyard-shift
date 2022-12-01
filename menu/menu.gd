extends Node


func _ready():
	$Control/Play.connect("on_click", self, "play")
	$Control/Settings.connect("on_click", self, "settings")
	$Control/Credits.connect("on_click", self, "credits")
	$Control/Exit.connect("on_click", self, "exit")
	
	$Sky2.material.set_shader_param("time_offset", OS.get_ticks_msec() / 1000.0)
	$Fog.material.set_shader_param("time_offset", OS.get_ticks_msec() / 1000.0 + 1)

var dead_switch = false
func _process(delta):
	if dead_switch || !OS.is_debug_build():
		return
	if Input.is_key_pressed(KEY_5):
		Game.skip_to_inventory = true
		dead_switch = true
		Deck.starting_deck = Deck.developer_deck
		Tutorial.skip = true
		Game.emit_signal("hard_reset")
		Game.emit_signal("change_scene", "res://shop.tscn")
	
func play():
	Game.emit_signal("change_scene", "res://main.tscn")
	
func settings():
	yield(get_tree().create_timer(0.0), "timeout")
	Game.emit_signal("open_settings")
	
func credits():
	Game.emit_signal("change_scene", "res://credits.tscn")
	
func exit():
	get_tree().quit()
