extends "res://hand/draggable_card.gd"

var index = 0

var start_translation

var selected = false

var inert = false


var f_tween
func _ready():
	foresight_card = true
	Game.connect("foresight_end", self, "on_foresight_end")
	var cam = get_viewport().get_camera()
	set_layer_mask(2)
	var v = get_viewport().size
	global_rotation = cam.global_rotation
	rotate_object_local(Vector3.UP, PI)
	global_translation = cam.project_position(Vector2.ZERO, 17.0)
	var target_translation = cam.project_position(Vector2(v.x / 2 + (index - 1) * v.x / 5.8, v.y / 2.4), 17.0)
	f_tween = Tween.new()
	add_child(f_tween)
	f_tween.interpolate_property(self, "global_translation", 
		global_translation,
		target_translation,
		0.4,
		Tween.TRANS_QUAD,
		Tween.EASE_OUT)
	f_tween.interpolate_property(self, "global_transform:basis", 
		global_transform.basis,
		cam.global_transform.scaled(scale).basis,
		0.5,
		Tween.TRANS_QUAD,
		Tween.EASE_OUT,
		0.4)
	f_tween.start()
	yield(f_tween, "tween_all_completed")
	start_translation = translation
	$FloatAnimation.play("float")
	$Tile.attach_selection_glow()

func on_foresight_end(card):
	inert = true
	selected = false
	# translation = start_translation
	$Tile.detach_glow()
	if card == self:
		foresight_card = false
		var cards = get_parent().get_node("Camera/Hand/Cards")
		get_parent().remove_child(self)
		cards.add_child(self)
		cards.get_parent().adjust_hand()
		return
	$FloatAnimation.stop()
	Deck.return_card(self.card)
	var cam = get_viewport().get_camera()
	var target_translation = cam.project_position(Vector2.ZERO, 17.0)
	var t2 = global_transform.rotated(global_transform.basis.y, -PI).basis
	print(global_transform.basis)
	f_tween.interpolate_property(self, "global_transform:basis", 
		global_transform.basis,
		t2,
		0.5,
		Tween.TRANS_QUAD,
		Tween.EASE_IN)
	f_tween.interpolate_property(self, "global_translation", 
		global_translation,
		target_translation,
		0.5,
		Tween.TRANS_QUAD,
		Tween.EASE_IN,
		0.4)
	f_tween.start()
	yield(f_tween, "tween_all_completed")
	queue_free()
	
func _input(event):
	if !selected || inert:
		return
	if event is InputEventMouseButton && event.pressed && event.button_index == 1:
		$FloatAnimation.play("RESET")
		Game.emit_signal("foresight_end", self)
		Game.block_interaction = false
		
func _process(delta):
	if start_translation == null || inert:
		return
	if selected:
		$Tile.set_selection_glow(true)
		translation = start_translation + get_viewport().get_camera().global_transform.basis.z
	else:
		$Tile.set_selection_glow(false)
		translation = start_translation
		
func _on_Area_mouse_entered():
	._on_Area_mouse_entered()
	selected = true
	
func _on_Area_mouse_exited():
	._on_Area_mouse_exited()
	selected = false
	
