extends Control

var ShopCard = preload("res://ui/shop_card.tscn")
var shopCard3D = preload("res://shop_card_3d.tscn")
var treasureCard3D = preload("res://ui/treasure_card_3d.tscn")
var Inventory = preload("res://inventory.tscn")


var cards
var bought

func _ready():
#	var merged_shop_theme = Theme.new()
#	merged_shop_theme.merge_with(Game.original_theme)
#	merged_shop_theme.merge_with($Shop.theme)
#	$Shop.theme = merged_shop_theme
	cards = []
	$AnimationPlayer.play("RESET")
	$Shop/TreasureView/AnimationPlayer.play("RESET")
	Game.connect("accept_treasure", self, "on_accept_treasure")
	
	$Shop.material.set_shader_param("time_offset", OS.get_ticks_msec() / 1000.0)
	for child in $"%Cards".get_children():
		$"%Cards".remove_child(child)
		child.queue_free()
		
	if Deck.pending_treasure_card == null:
		if Game.skip_to_inventory:
			Game.skip_to_inventory = false
			go_to_inventory()
		else:
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
	
func on_bought(c):
	bought[c.get_index()] = true
	
func deal_shop_cards():
	# Deal some cards
	cards = []
	bought = [false, false, false]
	cards.push_back(ShopDeck.deal())
	cards.push_back(ShopDeck.deal())
	cards.push_back(ShopDeck.deal())
	
	for card in cards:
		var new_card = ShopCard.instance()
		new_card.card = card
		$"%Cards".add_child(new_card)
		new_card.connect("bought", self, "on_bought", [new_card])
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
	
func undeal_shop_cards():
	for i in range(bought.size()):
		if !bought[i]:
			var card = cards[i]
			if !card:
				continue
			ShopDeck.return_card(card)
			
func _on_SkipButton_pressed():
#	Game.level += 1
#	Game.emit_signal("reset")
	undeal_shop_cards()
	$AnimationPlayer.play("fade_out")
	yield($AnimationPlayer, "animation_finished")
	# get_tree().change_scene("res://inventory.tscn")
	go_to_inventory()

func go_to_inventory():
	for child in $Shop.get_children():
		$Shop.remove_child(child)
	for child in $"%ShopCamera".get_children():
		$"%ShopCamera".remove_child(child)
	var inventory = Inventory.instance()
	inventory.controller = self
	$Shop.add_child(inventory)
	$AnimationPlayer.play("fade_in")
	inventory.fade_in()

func _process(delta):
	if $"%RerollButton" != null:
		$"%RerollButton".disabled = Game.money < 2
	
func _on_RerollButton_pressed():
	$"%RerollButton".release_focus()
	Game.money -= 2
	$AnimationPlayer.play("reroll_out")
	yield($AnimationPlayer, "animation_finished")
	undeal_shop_cards()
	for child in $"%Cards".get_children():
		$"%Cards".remove_child(child)
	for child in $"%ShopCamera".get_children():
		$"%ShopCamera".remove_child(child)
	deal_shop_cards()
	$AnimationPlayer.play("reroll_in")
