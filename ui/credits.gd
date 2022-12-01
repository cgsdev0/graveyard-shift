extends Node


func _ready():
	if !Game.beat:
		$"%HappyImg".visible = false
		$"%CheckImg".visible = false
	pass

var dead = false
func _process(delta):
	$Container.anchor_top -= delta / 20.0
	print ($Container.anchor_top)
	if Input.is_action_just_pressed("dialogue_confirm") && !dead:
		dead = true
		Game.emit_signal("change_scene", "res://menu.tscn")
	
