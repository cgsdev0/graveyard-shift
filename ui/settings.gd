extends PopupPanel


func _ready():
	Game.connect("open_settings", self, "open_settings")
	if OS.get_name() == "HTML5":
		$"%SSAO".disabled = true

func open_settings():
	show()
	$"%MusicVolume".grab_focus()
	$"%Fullscreen".pressed = OS.window_fullscreen
	$"%SSAO".pressed = Game.world_env.ssao_enabled
	$"%Bloom".pressed = Game.world_env.glow_enabled

func _on_SSAO_toggled(button_pressed):
	Game.world_env.ssao_enabled = button_pressed

func _on_Bloom_toggled(button_pressed):
	Game.world_env.glow_enabled = button_pressed

func _on_EffectsVolume_value_changed(value):
	if value == -20.0:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), false)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)

func _on_MusicVolume_value_changed(value):
	if value == -20.0:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), false)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)

func _on_Button_pressed():
	self.hide()

func _on_EffectsVolume_drag_ended(value_changed):
	yield(get_tree().create_timer(0.0), "timeout")
	$TestSound.play()

func _on_Fullscreen_toggled(button_pressed):
	OS.window_fullscreen = button_pressed
	hide()
	yield(get_tree().create_timer(0.0), "timeout")
	show()
	$"%Fullscreen".grab_focus()
