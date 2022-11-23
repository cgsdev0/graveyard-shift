extends Control

var ShopCard
var ShopCard3D

func _init():
	ShopCard = load("res://ui/shop_card.tscn")
	ShopCard3D = load("res://shop_card_3d.tscn")
		
func _ready():
#	var merged_shop_theme = Theme.new()
#	merged_shop_theme.merge_with(Game.original_theme)
#	merged_shop_theme.merge_with($Shop.theme)
#	$Shop.theme = merged_shop_theme
	
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
		if card == null:
			return
		var new_3d_card = ShopCard3D.instance()
		new_3d_card.follow_node = new_card.get_node("%3DAnchor")
		new_3d_card.become(card)
		$"%ShopCamera".add_child(new_3d_card)
		new_3d_card.global_rotation = Vector3.ZERO
		new_3d_card.global_translation = Vector3.ZERO
		

func _on_SkipButton_pressed():
#	Game.level += 1
#	Game.emit_signal("reset")
	for child in $Shop.get_children():
		$Shop.remove_child(child)
	for child in $"%ShopCamera".get_children():
		$"%ShopCamera".remove_child(child)
	var inventory = preload("res://inventory.tscn").instance()
	$Shop.add_child(inventory)
	# get_tree().change_scene("res://inventory.tscn")
