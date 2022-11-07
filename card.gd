class_name Card
extends Button

export(Game.TileType) var type

func _ready():
	self.text = Game.TileType.keys()[type]
	self.connect("pressed", self, "on_press")
	pass

func _process(delta):
	self.text = Game.TileType.keys()[type]
	self.visible = type != Game.TileType.EMPTY

func on_press():
	if type == Game.TileType.EMPTY:
		return
	Game.emit_signal("select_card", self)
	pass
