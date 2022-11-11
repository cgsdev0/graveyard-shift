extends Spatial


var mouse_cast
var dragging = null

var snap_tile = null

func _ready():
	var hand_pos = Vector2(get_viewport().size.x / 2, get_viewport().size.y / 5 * 4)
	$Area.rotation = get_viewport().get_camera().rotation
	$Area.global_translation = get_viewport().get_camera().project_position(hand_pos, 5)
	Game.connect("start_drag", self, "start_drag")
	pass

func set_snap_tile(tile):
	self.snap_tile = tile
	var mouse = get_viewport().get_mouse_position()
	var hand_pos = Vector2(get_viewport().size.x / 2, get_viewport().size.y / 5 * 4)
	var tween = dragging.get_node("Tween") as Tween
	if tile == null:
		tween.follow_property(dragging, "global_translation", 
			dragging.global_translation, 
			$Mouse,
			"global_translation",
			0.4, Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween.interpolate_property(dragging, "global_rotation", 
			dragging.global_rotation, 
			get_viewport().get_camera().global_rotation,
			0.4, Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween.start()
	else:
		tween.interpolate_property(dragging, "global_translation", 
			dragging.global_translation, 
			snap_tile.global_translation + snap_tile.size / 2 + Vector3(0, 0.1, 0),
			0.4, Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween.interpolate_property(dragging, "global_rotation", 
			dragging.global_rotation, 
			snap_tile.global_transform.basis.rotated(Vector3.RIGHT, -PI / 2).get_euler(),
			0.4, Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween.start()
func _process(delta):
	if dragging:
		var tween = dragging.get_node("Tween") as Tween
		if !Input.is_mouse_button_pressed(1):
			var hand_pos = Vector2(get_viewport().size.x / 2, get_viewport().size.y / 5 * 4)
			tween.interpolate_property(dragging, "global_translation", dragging.global_translation, get_viewport().get_camera().project_position(hand_pos, 5),
			0.4, Tween.TRANS_QUAD, Tween.EASE_OUT)
			tween.interpolate_property(dragging, "global_rotation", dragging.global_rotation, get_viewport().get_camera().global_rotation,
			0.4, Tween.TRANS_QUAD, Tween.EASE_OUT)
			tween.start()
			dragging = null
			return
		var mouse = get_viewport().get_mouse_position()
		if snap_tile == null:
			if tween.is_active():
				pass
			else:
				dragging.rotation = get_viewport().get_camera().rotation
				dragging.global_translation = get_viewport().get_camera().project_position(mouse, 5)

func _physics_process(delta):
	if dragging:
		var space = get_world().direct_space_state
		var mouse = get_viewport().get_mouse_position()
		var from = get_viewport().get_camera().project_ray_origin(mouse)
		var to = from + get_viewport().get_camera().project_ray_normal(mouse) * 600
		var result = space.intersect_ray(from, to, [], 0b10, false, true)
		if result.has("collider"):
			if result.collider.type == Game.TileType.EMPTY:
				if snap_tile != result.collider:
					set_snap_tile(result.collider)
		elif snap_tile != null:
			set_snap_tile(null)
		
func start_drag(card):
	if dragging == null:
		dragging = card
