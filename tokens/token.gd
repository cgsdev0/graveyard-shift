class_name Token
extends Spatial

var width = 0.2
var scale_factor = 120.0
export var albedo_color = Color.white
export var sprite_texture = preload("res://debug/rbetta.png")
export var sprite_mesh = preload("res://debug/rbetta_mesh.tres")

func _ready():	
	var mi = MeshInstance.new()
	mi.mesh = sprite_mesh
	
	var outline = mi.mesh.create_outline(0).surface_get_arrays(0)[0]
	outline.push_back(outline[0])
	var mdt = MeshDataTool.new()
	mdt.create_from_surface(mi.mesh, 0)
	
	for i in range(mdt.get_vertex_count()):
		var vertex = mdt.get_vertex(i)
		mdt.set_vertex(i, vertex / scale_factor)
	
	mi.mesh.surface_remove(0)
	mdt.commit_to_surface(mi.mesh)
	
	for i in range(mdt.get_vertex_count()):
		var vertex = mdt.get_vertex(i)
		mdt.set_vertex(i, vertex + Vector3(0, 0, width))
	mdt.commit_to_surface(mi.mesh)
	
	var st = SurfaceTool.new()
	st.clear()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in range(outline.size()):
		if i + 1 >= outline.size():
			break
		st.add_vertex(outline[i] / scale_factor)
		st.add_vertex(outline[i] / scale_factor + Vector3(0, 0, width))
		st.add_vertex(outline[i + 1] / scale_factor)
		st.add_vertex(outline[i] / scale_factor + Vector3(0, 0, width))
		st.add_vertex(outline[i + 1] / scale_factor + Vector3(0, 0, width))
		st.add_vertex(outline[i + 1] / scale_factor)
	st.generate_normals()
	st.commit(mi.mesh)

	mi.scale *= -1
	mi.scale.x = 1
	var mat = SpatialMaterial.new()
	mat.albedo_color = self.albedo_color
	mat.set_texture(SpatialMaterial.TEXTURE_ALBEDO, sprite_texture)
	mat.params_cull_mode = SpatialMaterial.CULL_DISABLED
	mi.set_surface_material(0, mat)
	mi.set_surface_material(1, mat)
	mi.set_surface_material(2, mat)
	self.add_child(mi)
