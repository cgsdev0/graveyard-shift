extends Area2D


func _ready():
	self.connect("mouse_entered", self, "_on_Area2D_mouse_entered")
	self.connect("mouse_exited", self, "_on_Area2D_mouse_exited")
	if OS.get_name() == "HTML5" && name == "Exit":
		visible = false

var mouse_in = false

func _on_Area2D_mouse_entered():
	mouse_in = visible
	modulate = Color.white
	
func _on_Area2D_mouse_exited():
	mouse_in = false
	modulate = Color.black

func _input(event):
	if !mouse_in:
		return
	if event is InputEventMouseButton && event.pressed && event.button_index == 1:
		self.emit_signal("on_click")
		
signal on_click
