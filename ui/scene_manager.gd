extends Node2D


func _ready():
	Game.connect("change_scene", self, "on_transition")
	yield(get_tree().create_timer(0.1), "timeout")
	$AudioStreamPlayer.play()
	
func on_transition(path):
	$CanvasLayer.transition()
	yield($CanvasLayer, "transitioned")
	var child = $CurrentScene.get_child(0)
	$CurrentScene.remove_child(child)
	child.queue_free()
	var shop = load(path).instance()
	$CurrentScene.add_child(shop)
