extends Button


func _ready():
	pass

func _process(delta):
	disabled = (Deck.selected_deck.size() != Deck.max_deck_size)
