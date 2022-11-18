extends Control


func _ready():
	var merged_shop_theme = Theme.new()
	merged_shop_theme.merge_with(Game.original_theme)
	merged_shop_theme.merge_with($Shop.theme)
	$Shop.theme = merged_shop_theme


func _on_SkipButton_pressed():
	Game.level += 1
	Game.emit_signal("reset")
	get_tree().change_scene("res://main.tscn")
