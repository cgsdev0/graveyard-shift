extends Control


func _ready():
	var merged_shop_theme = Theme.new()
	merged_shop_theme.merge_with(Game.original_theme)
	merged_shop_theme.merge_with($Shop.theme)
	$Shop.theme = merged_shop_theme
