extends PopupPanel


func _ready():
	pass

func _input(event):
	if Game.current_path == "res://menu.tscn":
		return
	if Game.block_pause:
		return
	if event is InputEventKey && event.pressed && (event.scancode == KEY_ESCAPE || event.scancode == KEY_P):
		toggle()
		
func _process(delta):
	$M/V/Inventory.visible = Game.current_path == "res://main.tscn"
	$M/V/Shop.visible = Game.current_path == "res://main.tscn"
	$M/V/Restart.visible = Game.current_path == "res://main.tscn"

func set_toggle(v):
	if !v:
		get_tree().paused = false
		hide()
	else:
		get_tree().paused = true
		show()
		
func toggle():
	set_toggle(!visible)

func _on_Resume_pressed():
	set_toggle(false)

func _on_Settings_pressed():
	Game.emit_signal("open_settings")

func _on_Quit_pressed():
	$"%QuitConfirm".show()

func _on_CancelQuit_pressed():
	$"%QuitConfirm".hide()

func _on_ActuallyQuit_pressed():
	Game.emit_signal("change_scene", "res://menu.tscn")
	set_toggle(false)
	$"%QuitConfirm".hide()
	Game.emit_signal("hard_reset")


func _on_Restart_pressed():
	Game.reset_money()
	Game.emit_signal("reset")
	set_toggle(false)
	Game.emit_signal("change_scene", "res://main.tscn")


func _on_Shop_pressed():
	Game.reset_money()
	Game.emit_signal("reset")
	set_toggle(false)
	Game.emit_signal("change_scene", "res://shop.tscn")


func _on_Inventory_pressed():
	Game.skip_to_inventory = true
	Game.reset_money()
	Game.emit_signal("reset")
	set_toggle(false)
	Game.emit_signal("change_scene", "res://shop.tscn")
