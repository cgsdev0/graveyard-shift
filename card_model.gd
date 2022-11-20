tool
extends Spatial

export var header = 0.0 setget _set_header
export var decal_bits = 0 setget _set_decal_bits
export var decal_scale = 1.0 setget _set_decal_scale
export var decal_v_offset = 0.0 setget _set_decal_v_offset

func set_debug_tint(v):
	if $Plane.get_surface_material(0) == null:
		return
	$Plane.get_surface_material(0).set_shader_param("debug_tint", v)
	$Plane.get_surface_material(0).set_shader_param("has_debug_tint", true)
	
func scale_up_walls():
	$AnimationPlayer.play("scale_up_walls")

func _set_header(v):
	if $Plane.get_surface_material(0) == null:
		return
	$Plane.get_surface_material(0).set_shader_param("fade_c", v)
	header = v

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
	
func _ready():
	pass
