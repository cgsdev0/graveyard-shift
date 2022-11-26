extends Area

export(Game.SlotType) var slot_type
export(Game.TileType) var type
var wall_flags = [0, 0, 0, 0]

var disabled = false
var placed = false
var placed_at

var old_index

var card

var mutable_card

var foresight_card = false

func show_error(show):
	$Tile.visible = !show
	$NoPlace.visible = show
	
func discard_animation(index):
	var tween = Tween.new()
	add_child(tween)
	var target_a = get_viewport().get_camera().project_position(get_viewport().size / 2, 15.0 + index * 0.5)
	tween.interpolate_property(self, "global_translation", global_translation,
	target_a, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.interpolate_property(self, "global_translation", target_a,
	get_viewport().get_camera().project_position(Vector2.ZERO, 15.0 + index * 0.5), 
	0.5, Tween.TRANS_QUAD, Tween.EASE_IN, 0.55 + 0.1 * index)
	tween.start()
	yield(tween, "tween_all_completed")
	queue_free()
	
func placement_animation():
	match type:
		Game.TileType.WALL, Game.TileType.SECRET_DOOR:
			$Tile.play_animation("scale_up_walls")
		Game.TileType.BRIDGE:
			$Tile.play_animation("scale_up_bridge")
		Game.TileType.MONEY_TREE, Game.TileType.LURE, Game.TileType.COURAGE, Game.TileType.GUST:
			$Tile.play_animation("fade_out_all")
		Game.TileType.ACTION_SURGE, Game.TileType.FORESIGHT, Game.TileType.FRESH_START:
			var anim_list = $AnimationPlayer.get_animation_list()
			var i = randi() % anim_list.size()
			$AnimationPlayer.play(anim_list[i], -1, 0.8)
			yield($AnimationPlayer, "animation_finished")
			queue_free()
		_:
			$Tile.play_animation("fade_out_header")

func recompute_wall_decals():
	if mutable_card.has("wall_flags"):
		mutable_card.wall_flags = wall_flags
	$Tile.recompute_wall_decals(mutable_card)
	
func become(card):
	self.card = card
	self.mutable_card = card.duplicate(true)
	self.type = card.type
	self.wall_flags = card.get("wall_flags", [])
	$Tile.become(card)
	$Tile.recompute_wall_decals(card)

			
var board
	
func _ready():
	board = Game.get_board()

func check_wall_bit(flag):
	return wall_flags[flag]
	
func _process(delta):
	self.disabled = Game.actions < card.ac

func set_translation(glob):
	global_translation = glob
	
func set_layer_mask(layer):
	$Tile.get_node("Plane").set_layer_mask(layer)
	$Label3D.set_layer_mask(layer)
	
func _on_Area_input_event(camera, event, position, normal, shape_idx):
	if disabled || foresight_card:
		return
	if event is InputEventMouseButton && event.button_index == 1:
		if event.pressed:
			var offset = position - global_translation
			Game.emit_signal("start_drag", self, offset)


func _on_Area_mouse_entered():
	if disabled || foresight_card:
		return
	Game.emit_signal("start_hover", self)


func _on_Area_mouse_exited():
	if disabled || foresight_card:
		return
	Game.emit_signal("end_hover", self)
