extends MarginContainer

func flags_to_bits(flags):
	var bits = 0
	for i in range(flags.size()):
		if flags[i]:
			bits |= 1 << i
	return bits
	
var card
var color: Color
func become(card):
	self.card = card
	$"%Label".text = Game.title_card(card)
	color = Deck.card_color(card)
	color = Color.darkorchid
	$ColorRect.color = color
	if Game.is_wall(card.type):
		var bits = flags_to_bits(card.wall_flags)
		$"%WallIndicator".texture.region.position.y = float(bits / 4 * 24)
		$"%WallIndicator".texture.region.position.x = float(bits % 4 * 24)
	else:
		$"%WallIndicator".texture = null

func check_box(v = true):
	$"%CheckBox".pressed = v

signal toggled(button_pressed)

func _on_CheckBox_toggled(button_pressed):
	if Deck.selected_deck.size() >= Deck.max_deck_size && button_pressed:
		return
	self.emit_signal("toggled", button_pressed)

func _process(delta):
	if Deck.selected_deck.size() >= Deck.max_deck_size && !$"%CheckBox".pressed:
		$"%CheckBox".disabled = true
		$ColorRect.color = color
		$"%Label".modulate = Color(1.0, 1.0, 1.0, 0.5)
	else:
		
		$"%CheckBox".disabled = false
		if $"%CheckBox".pressed:
			$ColorRect.color = color.darkened(0.5)
			$"%Label".modulate = Color(1.0, 1.0, 1.0, 0.5)
		else:
			$ColorRect.color = color
			$"%Label".modulate = Color.white


func _on_MarginContainer_gui_input(event):
	if event is InputEventMouseButton && event.pressed && event.button_index == 1:
		if $"%CheckBox".disabled:
			return
		$"%CheckBox".pressed = !$"%CheckBox".pressed
