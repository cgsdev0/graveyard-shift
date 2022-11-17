class_name TokenGenerator
extends Node2D

var width = 0.2
export var scale_factor = 100.0

var mi

var points = []
var p

func to_vec3(v2):
	return Vector3(v2.x, v2.y, 0)
func _ready():	
	if get_tree().root.get_child(get_tree().root.get_child_count() - 1) != self:
		return
		
	$Control/FileOpen.popup()
	var path = yield($Control/FileOpen, "file_selected")
	$Sprite.texture = load(path)
	
	mi = MeshInstance.new()
	var image = Image.new()
	image.load($Sprite.texture.resource_path)

	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(image)
	var polygons = bitmap.opaque_to_polygons(Rect2(Vector2(0, 0), bitmap.get_size()))
	
	p = []
	var sz = $Sprite.texture.get_size()
	sz = Vector2(sz.x / 2, sz.y)
	for point in polygons[0]:
		p.push_back(point - sz)
		
	var triangulated = Geometry.triangulate_polygon(p)
	for t in triangulated:
		points.push_back(p[t])
	var tool2d = SurfaceTool.new()
	tool2d.begin(Mesh.PRIMITIVE_TRIANGLES)
	for point in points:
		tool2d.add_vertex(to_vec3(point))
	var arr_mesh = tool2d.commit()
	var mi2d = MeshInstance2D.new()
	mi2d.modulate = Color.yellow
	mi2d.modulate.a = 0.4
	mi2d.mesh = arr_mesh
	$Sprite.add_child(mi2d)
	mi2d.translate(Vector2(0, sz.y / 2))
	update()
	mi.mesh = mi2d.mesh.duplicate()
	
	var outline = p
	outline.push_back(outline[0])
	var mdt = MeshDataTool.new()
	mdt.create_from_surface(mi.mesh, 0)
	
	var w_off = Vector3(0, 0, width) / 2.0
	for i in range(mdt.get_vertex_count()):
		var vertex = mdt.get_vertex(i)
		mdt.set_vertex(i, vertex / scale_factor - w_off)
		mdt.set_vertex_uv(i, Vector2(vertex.x / $Sprite.texture.get_width() + 0.5, vertex.y  / $Sprite.texture.get_height() + 1.0))
	
	mi.mesh.surface_remove(0)
	mdt.commit_to_surface(mi.mesh)
	
	for i in range(mdt.get_vertex_count()):
		var vertex = mdt.get_vertex(i)
		mdt.set_vertex(i, vertex + w_off * 2.0)
	mdt.commit_to_surface(mi.mesh)
	
	var st = SurfaceTool.new()
	st.clear()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in range(outline.size()):
		if i + 1 >= outline.size():
			break
		
		st.add_vertex(to_vec3(outline[i]) / scale_factor - w_off)
		st.add_vertex(to_vec3(outline[i]) / scale_factor + w_off)
		st.add_vertex(to_vec3(outline[i + 1]) / scale_factor - w_off)
		st.add_vertex(to_vec3(outline[i]) / scale_factor + w_off)
		st.add_vertex(to_vec3(outline[i + 1]) / scale_factor + w_off)
		st.add_vertex(to_vec3(outline[i + 1]) / scale_factor - w_off)
	st.generate_normals()
	st.commit(mi.mesh)

	mi.scale *= -1
	mi.scale.x = 1
	var splitted = path.rsplit("/", true, 1)
	$Control/FileSave.set_current_file(splitted[1].replace(".png", "_mesh.tres"))
	$Control/FileSave.popup()
	$Control/FileSave.set_current_dir(splitted[0])
	$Control/FileSave.deselect_items()
	


func _draw():
	if !p || !points:
		return
	var sz = $Sprite.texture.get_size() / 2
	sz.x = 0
	for i in range(0, points.size(), 3):
		draw_line(points[i] + $Sprite.position + sz, points[i+1] + $Sprite.position + sz, Color.red)
		draw_line(points[i+1] + $Sprite.position + sz, points[i+2] + $Sprite.position + sz, Color.red)
		draw_line(points[i] + $Sprite.position + sz, points[i+2] + $Sprite.position + sz, Color.red)
	for i in p.size() - 1:
		draw_line(p[i] + $Sprite.position + sz, p[i+1] + $Sprite.position + sz, Color.green)
		pass


func _on_FileDialog_file_selected(path):
	ResourceSaver.save(path, mi.mesh)
