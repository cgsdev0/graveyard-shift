extends Control

var preview

func _ready():
	$"%PreviewTarget".texture = null
	
	for card in Deck.starting_deck:
		var row = preload("res://inventory_row.tscn").instance()
		row.become(card)
		$VBoxContainer.add_child(row)
		row.connect("mouse_entered", self, "on_hover_row", [row])
		
	preview = preload("res://shop_card_3d.tscn").instance()
	preview.follow_node = $"%PreviewTarget"
	preview.become(Deck.starting_deck[0])
	$"%ShopCamera".add_child(preview)
	preview.global_rotation = Vector3.ZERO
	preview.global_translation = Vector3.ZERO
		
func on_hover_row(row):
	preview.become(row.card)
	print(row.card)
