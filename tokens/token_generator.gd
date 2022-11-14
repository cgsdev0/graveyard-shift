class_name TokenGenerator
extends Node2D

var width = 0.2
export var scale_factor = 100.0

var mi

var points = []
	
func _ready():	
	if get_tree().root.get_child(get_tree().root.get_child_count() - 1) != self:
		print("NOPE")
		return
	mi = MeshInstance.new()
	
	var image = Image.new()
	image.load($Sprite.texture.resource_path)

	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(image)
	var polygons = bitmap.opaque_to_polygons(Rect2(Vector2(0, 0), bitmap.get_size()))
	
	var p = polygons[0]
	var triangulated = Geometry.triangulate_polygon(p)
	for t in triangulated:
		points.push_back(p[t])
	var tool2d = SurfaceTool.new()
	tool2d.begin(Mesh.PRIMITIVE_TRIANGLES)
	for point in points:
		tool2d.add_vertex(Vector3(point.x, point.y, 0))
	var arr_mesh = tool2d.commit()
	print(arr_mesh)
	var mi2d = MeshInstance2D.new()
	mi2d.mesh = arr_mesh
	$Sprite.add_child(mi2d)
	update()
	mi.mesh = mi2d.mesh.duplicate()
	
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
	$Control/FileDialog.popup()
	


func _draw():
	for i in points.size() - 1:
		draw_line(points[i] + $Sprite.position, points[i+1] + $Sprite.position, Color.green)
		pass


func _on_FileDialog_file_selected(path):
	ResourceSaver.save(path, mi.mesh)
