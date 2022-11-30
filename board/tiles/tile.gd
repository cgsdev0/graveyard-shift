class_name Tile
extends Area


export var size = Vector3(100, 5, 100)
var spacing = 0.0
var color: Color = Color.white
var type = Game.TileType.EMPTY
var wall_flags = [0, 0, 0, 0]
var spikes_ready = false

var stacks = 0
var title

func _ready():
	var tiles = get_parent().cols * get_parent().rows
	yield(get_tree().create_timer(0.5 + 0.8 * get_index() / tiles), "timeout")
	$AnimationPlayer.play("fall")
	
func get_title():
	if title:
		return title
	return Game.title_card(self)
	
func refresh_type():
	$TileMesh.become({ "type": self.type })
	
func get_center() -> Vector3:
	return global_translation + size / 2 + Vector3(0, 0.1 + 0.06 * stacks, 0)
	
func init(s: Vector3, t: Vector3, spacing: float) -> void:
	size = s
	translation = t
	self.spacing = spacing
	
func set_selection_glow(v):
	$TileMesh.set_selection_glow(v)
	
func set_selection_glow_color(v):
	$TileMesh.set_selection_glow_color(v)
	
func on_start_new_turn():
	if type == Game.TileType.SPIKES && !spikes_ready:
		self.emit_signal("spikes_ready")
		spikes_ready = true
		
signal spikes_ready

func on_board_ready():
	Game.connect("start_new_turn", self, "on_start_new_turn")
	$CollisionShape2D.shape.extents = size / 2 + Vector3(spacing / 2, 0, spacing / 2)
	$CollisionShape2D.translation = size / 2
	$TileMesh.attach_selection_glow()
	refresh_type()

func check_wall_bit(flag):
	return wall_flags[flag]
