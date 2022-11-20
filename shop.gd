extends Control

var ShopCard

func _init():
	ShopCard = load("res://ui/shop_card.tscn")
		
func _ready():
	var merged_shop_theme = Theme.new()
	merged_shop_theme.merge_with(Game.original_theme)
	merged_shop_theme.merge_with($Shop.theme)
	$Shop.theme = merged_shop_theme
	
	for child in $"%Cards".get_children():
		$"%Cards".remove_child(child)
		child.queue_free()
	
	# Deal some cards
	var cards = []
	cards.push_back(ShopDeck.deal(0))
	cards.push_back(ShopDeck.deal(1))
	cards.push_back(ShopDeck.deal(2))
	
	for card in cards:
		var new_card = ShopCard.instance()
		new_card.card = card
		$"%Cards".add_child(new_card)

func _on_SkipButton_pressed():
	Game.level += 1
	Game.emit_signal("reset")
	get_tree().change_scene("res://main.tscn")
