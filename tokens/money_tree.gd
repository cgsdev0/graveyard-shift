extends Token

var gpm = 1

func _ready():
	add_to_group("money_trees")
	add_to_group("killable_tokens")
	
func kill():
	remove_from_group("money_trees")
	remove_from_group("killable_tokens")
	remove_from_group("tokens")
	queue_free()

func tick():
	Game.money += gpm
