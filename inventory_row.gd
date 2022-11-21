extends MarginContainer

func flags_to_bits(flags):
	var bits = 0
	for i in range(flags.size()):
		if flags[i]:
			bits |= 1 << i
	return bits
	
var card
func become(card):
	self.card = card
	$"%Label".text = Game.TileType.keys()[card.type]
	$ColorRect.color = Deck.card_color(card)
	if Game.is_wall(card.type):
		$"%WallIndicator".visible = true
		var bits = flags_to_bits(card.wall_flags)
		$"%WallIndicator".texture.region.position.y = float(bits / 4 * 24)
		$"%WallIndicator".texture.region.position.x = float(bits % 4 * 24)
		print($"%WallIndicator".texture.region.position)
	else:
		$"%WallIndicator".visible = false
