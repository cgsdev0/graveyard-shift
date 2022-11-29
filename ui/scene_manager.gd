extends Node2D


func _ready():
	Game.connect("change_scene", self, "on_transition")
	yield(get_tree().create_timer(0.1), "timeout")
	var env = load("res://not_default_env.tres")
	Game.world_env = env
	if OS.get_name() == "HTML5":
		env.ssao_enabled = false
	$AudioStreamPlayer.play()
	
func on_transition(path):
	$CanvasLayer.transition()
	yield($CanvasLayer, "transitioned")
	Game.current_path = path
	var child = $CurrentScene.get_child(0)
	$CurrentScene.remove_child(child)
	child.queue_free()
	var shop = load(path).instance()
	$CurrentScene.add_child(shop)
