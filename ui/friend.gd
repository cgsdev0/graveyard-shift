extends Node2D

var outline_shader = preload("res://shaders/friend_outline.gdshader")

func _ready():
	$FriendBody.material.set_shader_param("line_color", Color.aqua)
	$FriendBody.material.set_shader_param("line_thickness", 9.0)
	Game.connect("highlight_friend", self, "highlight")
	$FriendBody/AnimationPlayer.play("bounce")

var celebrating = false
func celebrate_card():
	celebrating = true
	$"%Face3D".set_face_happy()
	yield(get_tree().create_timer(2.5), "timeout")
	$"%Face3D".set_face_default()
	celebrating = false
	
	
func _process(delta):
	var v = get_viewport().size
	var scale_factor = min(v.x / 800.0, v.y / 450.0) * 0.22
	if bumped:
		scale_factor *= 1.3
	scale = Vector2(scale_factor, scale_factor) 
	
func highlight(v):
	if v:
		$FriendBody.material.shader = outline_shader
	else:
		$FriendBody.material.shader = null

var bumped = false
func bump():
	bumped = true
	$"%Face3D".set_face_happy()
	pass
	# margin_top = -50
	
func unbump():
	bumped = false
	if !celebrating:
		$"%Face3D".set_face_default()
	# margin_top = 0
	
