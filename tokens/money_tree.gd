extends Token

var gpm = 1

func _ready():
	add_to_group("money_trees")
	add_to_group("killable_tokens")
	var start_tween = Tween.new()
	add_child(start_tween)
	scale = Vector3(0, 1, 1)
	start_tween.interpolate_property(self, "scale", scale, Vector3(1,1,1),
	1.1, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	start_tween.start()

func kill():
	remove_from_group("money_trees")
	remove_from_group("killable_tokens")
	remove_from_group("tokens")
	queue_free()

func tick():
	Game.money += gpm
