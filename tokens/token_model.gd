class_name TokenModel
extends MeshInstance

var width = 0.2
export var scale_factor = 120.0
export var albedo_color = Color.white
export var sprite_texture = preload("res://debug/rbetta.png")

func _ready():	
	var mat = SpatialMaterial.new()
	mat.albedo_color = self.albedo_color
	mat.set_texture(SpatialMaterial.TEXTURE_ALBEDO, sprite_texture)
	mat.params_cull_mode = SpatialMaterial.CULL_DISABLED
	set_surface_material(0, mat)
	set_surface_material(1, mat)
	set_surface_material(2, mat)
	scale *= -1
	scale.x = 1
