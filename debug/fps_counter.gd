extends Label

func _ready():
	visible = OS.is_debug_build()
	
func _process(delta):
	if !visible:
		return
	var shop_deck_size = 0
	for deck in ShopDeck.deck:
		shop_deck_size += deck.size()
	var r = ShopDeck.rarities()
	var arr = [
		"FPS: " + str(Engine.get_frames_per_second()),
		"Cards in deck: " + str(Deck.deck.size()),
		"Cards in shop deck: " + str(shop_deck_size),
		"Tier 1 rarity: " + str(r[1]),
		"Tier 2 rarity: " + str(r[0] - r[1]),
		"Tier 3 rarity: " + str(1.0 - r[0]),
		"Turns: " + str(Game.turns),
		]
	text = "\n".join(arr)

func _input(event):
	if OS.is_debug_build() && event is InputEventKey and Input.is_key_pressed(KEY_PAGEDOWN):
		visible = !visible
	if OS.is_debug_build() && event is InputEventKey and Input.is_key_pressed(KEY_EQUAL):
		Game.money += 1
