class_name ShopCard3D
extends Spatial

var follow_node
var card
	
func become(card):
	self.card = card
	$Card.become(card)
	$Card.recompute_wall_decals(card)
		

var tween: Tween
var hover_time: float = 0.0

func _ready():
	tween = Tween.new()
	add_child(tween)
	pass

func _process(delta):
	do_process(delta)
	
var inside = false
func do_process(delta):
	var cam = get_parent() as Camera
	global_translation = cam.project_position(follow_node.rect_global_position + follow_node.rect_size / 2.0, 20.0)
	var pos1 = cam.unproject_position(global_translation)
	var pos2 = cam.unproject_position(global_translation + Vector3(0, 2.2, 2.2))
	var bb = (pos1 - pos2) * 2.0
	var bb_size = max(abs(bb.x), abs(bb.y))
	var parent_bb_size = min(follow_node.rect_size.x, follow_node.rect_size.y)
	var sf = parent_bb_size / bb_size
	
	var scaled_rect = Rect2(pos1 - Vector2(bb_size, bb_size) * sf / 2.0, Vector2(bb_size, bb_size) * sf)
	# get_parent().get_parent().get_parent().get_node("Node2D").rects.push_back(scaled_rect)
	
	if scaled_rect.has_point(get_viewport().get_mouse_position()):
		if !inside:
			$SubtleSound.play()
		inside = true
		tween.set_active(false)
		hover_time += delta
		global_rotation = Vector3.ZERO
		var target = clamp((pos1.x - get_viewport().get_mouse_position().x) / scaled_rect.size.x, -1, 1)
		rotate(Vector3(0, 0.8, 0.2).normalized(), lerp(0, target, ease(clamp(hover_time * 5.0, 0, 1), 0.5)))
	elif hover_time > 0.0:
		$SubtleSound.play()
		inside = false
		hover_time = 0.0
		tween.interpolate_property(self, "global_rotation", global_rotation, Vector3.ZERO, 0.4, Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween.start()
		
	scale = Vector3(sf, sf, sf)
	

