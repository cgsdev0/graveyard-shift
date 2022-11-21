extends Control

var preview

func _ready():
	$"%PreviewTarget".texture = null
	
	for i in range(Deck.starting_deck.size()):
		var card = Deck.starting_deck[i]
		var row = preload("res://inventory_row.tscn").instance()
		row.become(card)
		$VBoxContainer.add_child(row)
		row.connect("mouse_entered", self, "on_hover_row", [row])
		row.connect("toggled", self, "on_toggle_row", [i])
		if i in Deck.selected_deck:
			row.check_box()
		
	preview = preload("res://shop_card_3d.tscn").instance()
	preview.follow_node = $"%PreviewTarget"
	preview.become(Deck.starting_deck[0])
	$"%ShopCamera".add_child(preview)
	preview.global_rotation = Vector3.ZERO
	preview.global_translation = Vector3.ZERO

func on_toggle_row(state, index):
	if state:
		if !Deck.selected_deck.has(index):
			Deck.selected_deck.push_front(index)
	else:
		Deck.selected_deck.erase(index)

func _process(delta):
	$"%DeckLabel".text = str(Deck.selected_deck.size()) + " / " + str(Deck.max_deck_size) + " cards in deck"
	
func on_hover_row(row):
	preview.become(row.card)
