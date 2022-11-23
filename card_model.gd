tool
extends Spatial

export var header_tint: Color = Color.red setget _set_header_tint
export var header = 0.0 setget _set_header
export var decal_bits = 0 setget _set_decal_bits
export var decal_scale = 1.0 setget _set_decal_scale
export var decal_v_offset = 0.0 setget _set_decal_v_offset

var glow_shader = preload("res://shaders/card_glow_pass.tres")

func set_debug_tint(v):
	if $Plane.get_surface_material(0) == null:
		return
	$Plane.get_surface_material(0).set_shader_param("debug_tint", v)
	$Plane.get_surface_material(0).set_shader_param("has_debug_tint", true)

func enable_hearts(n):
	for child in $"%HeartContainer".get_children():
		child.visible = false
	for i in range(min(n, $"%HeartContainer".get_child_count())):
		$"%HeartContainer".get_child(i).visible = true
	$Viewport.render_target_update_mode = Viewport.UPDATE_ONCE
		
func play_animation(anim):
	$AnimationPlayer.play(anim)
	
var original_decal1 = preload("res://textures/cards/walls/N.png")

func enable_glow():
	var pass2 = ShaderMaterial.new()
	pass2.shader = glow_shader
	$Plane.get_surface_material(0).next_pass = pass2
	
func adjust_glow(adjust):
	$Plane.get_surface_material(0).next_pass.set_shader_param("glow_adjust", adjust)
	
func override_decal(tex):
	if tex == null:
		tex = original_decal1
	$Plane.get_surface_material(0).set_shader_param("decal_1", tex)

func _set_header(v):
	if $Plane.get_surface_material(0) == null:
		return
	$Plane.get_surface_material(0).set_shader_param("fade_c", v)
	header = v

func _set_header_tint(v):
	if $Plane.get_surface_material(0) == null:
		return
	$Plane.get_surface_material(0).set_shader_param("tint", v)
	header_tint = v

func _set_decal_bits(v):
	if $Plane.get_surface_material(0) == null:
		return
		
	$Plane.get_surface_material(0).set_shader_param("decal_bits", v)
	decal_bits = v
	
func _set_decal_scale(v):
	if $Plane.get_surface_material(0) == null:
		return
	$Plane.get_surface_material(0).set_shader_param("b_scale", v)
	decal_scale = v
	
func _set_decal_v_offset(v):
	if $Plane.get_surface_material(0) == null:
		return
	$Plane.get_surface_material(0).set_shader_param("v_offset", v)
	decal_v_offset = v
	
func set_text(action_cost, card_name):
	$"%ActionCost".text = str(action_cost)
	$"%CardName".text = str(card_name)
	$Viewport.render_target_update_mode = Viewport.UPDATE_ONCE
	
func _ready():
	$Plane.get_surface_material(0).set_shader_param("label", $Viewport.get_texture())
	$Plane.get_surface_material(0).set_shader_param("has_viewport", true)
