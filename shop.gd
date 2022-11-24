extends Control

var ShopCard
var shopCard3D
var treasureCard3D

func _init():
	ShopCard = load("res://ui/shop_card.tscn")
	shopCard3D = load("res://shop_card_3d.tscn")
	treasureCard3D = load("res://ui/treasure_card_3d.tscn")
		
func _ready():
#	var merged_shop_theme = Theme.new()
#	merged_shop_theme.merge_with(Game.original_theme)
#	merged_shop_theme.merge_with($Shop.theme)
#	$Shop.theme = merged_shop_theme
	Game.connect("accept_treasure", self, "on_accept_treasure")
	
	for child in $"%Cards".get_children():
		$"%Cards".remove_child(child)
		child.queue_free()
		
	if Deck.pending_treasure_card == null:
		$AnimationPlayer.play("fade_in")
		yield(get_tree().create_timer(0.1), "timeout")
		deal_shop_cards()
		$Shop/Container.visible = true
	else:
		$Shop/TreasureView/AnimationPlayer.play("new_treasure")
		var new_3d_card = treasureCard3D.instance()
		new_3d_card.become(Deck.pending_treasure_card)
		$"%ShopCamera".add_child(new_3d_card)

func on_accept_treasure():
	$Shop/TreasureView/AnimationPlayer.play("fade_out")
	yield($Shop/TreasureView/AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("fade_in")
	yield(get_tree().create_timer(0.1), "timeout")
	deal_shop_cards()
	
func deal_shop_cards():
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
		var new_3d_card = shopCard3D.instance()
		new_3d_card.follow_node = new_card.get_node("%3DAnchor")
		new_3d_card.become(card)
		$"%ShopCamera".add_child(new_3d_card)
		new_3d_card.global_rotation = Vector3.ZERO
		new_3d_card.global_translation = Vector3.ZERO
		

func get_shop_cam():
	return $"%ShopCamera"
	
func _on_SkipButton_pressed():
#	Game.level += 1
#	Game.emit_signal("reset")
# TODO: send un-purchased cards back to the shop deck
	$AnimationPlayer.play("fade_out")
	yield($AnimationPlayer, "animation_finished")
	for child in $Shop.get_children():
		$Shop.remove_child(child)
	for child in $"%ShopCamera".get_children():
		$"%ShopCamera".remove_child(child)
	var inventory = preload("res://inventory.tscn").instance()
	inventory.controller = self
	$Shop.add_child(inventory)
	$AnimationPlayer.play("fade_in")
	inventory.fade_in()
	# get_tree().change_scene("res://inventory.tscn")
