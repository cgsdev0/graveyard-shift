class_name Token
extends Spatial

var width = 0.2
export var scale_factor = 120.0
export var albedo_color = Color.white
export var sprite_texture = preload("res://debug/rbetta.png")
export var sprite_mesh = preload("res://debug/rbetta_mesh.tres")

func _ready():	
	var mi = MeshInstance.new()
	mi.mesh = sprite_mesh
	var mat = SpatialMaterial.new()
	mat.albedo_color = self.albedo_color
	mat.set_texture(SpatialMaterial.TEXTURE_ALBEDO, sprite_texture)
	mat.params_cull_mode = SpatialMaterial.CULL_DISABLED
	mi.set_surface_material(0, mat)
	mi.set_surface_material(1, mat)
	mi.set_surface_material(2, mat)
	mi.scale *= -1
	mi.scale.x = 1
	self.add_child(mi)
