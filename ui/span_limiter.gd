tool
class_name SpanLimiter
extends Container

enum Align { LEFT, CENTER, RIGHT }
enum VAlign { TOP, CENTER, BOTTOM }

const MAX_FLOAT := 10000000 #INF
# BUG: When saving scene with x or y of Vector2 set to inf, game crashes with
# E _parse_node_tag: res://scene.tscn:${line with "Vector2( inf, inf )"} - Parse Error: Expected float in constructor
#  <C++ Source>  scene/resources/resource_format_text.cpp:278 @ _parse_node_tag()
# Tested with Godot 3.3.2

export var rect_max_size: Vector2 = Vector2(MAX_FLOAT, MAX_FLOAT) setget set_custom_maximum_size
func set_custom_maximum_size(to):
	rect_max_size = to
	fit_child()

export(Align) var align = Align.CENTER setget set_align
func set_align(to):
	align = to
	fit_child()

export(VAlign) var valign = VAlign.CENTER setget set_valign
func set_valign(to):
	valign = to
	fit_child()

func _get_configuration_warning():
	if get_child_count() != 1:
		return "This node is designed for use with a single child"
	return ""

func _notification(what):
	if what == NOTIFICATION_RESIZED:
		fit_child()

func fit_child():
	
	if get_child_count() == 0:
		return
	
	var position = Vector2.ZERO
	var size = rect_size
	match align:
		Align.CENTER:
			position.x = max(0, (rect_size.x - rect_max_size.x) / 2)
		Align.RIGHT:
			position.x = max(0, rect_size.x - rect_max_size.x)
	
	match valign:
		VAlign.CENTER:
			position.y = max(0, (rect_size.y - rect_max_size.y) / 2)
		VAlign.BOTTOM:
			position.y = max(0, rect_size.y - rect_max_size.y)
	
	size.x = min(rect_size.x, rect_max_size.x)
	size.y = min(rect_size.y, rect_max_size.y)
	
	fit_child_in_rect(get_child(0), Rect2(position, size))

func _get_minimum_size():
	if get_child_count() != 0:
		return Vector2(
			max(rect_min_size.x, get_child(0).rect_min_size.x),
			max(rect_min_size.y, get_child(0).rect_min_size.y)
		)
	else:
		return rect_min_size
