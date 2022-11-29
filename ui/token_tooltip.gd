extends PanelContainer

func set_action_label(actions, base_actions):
	if actions == base_actions:
		$Body/Actions/Value.bbcode_text = str(actions)
		print("'", str(actions), "'")
		return
	var color = "lime"
	if actions < base_actions:
		color = "#ed3838"
	$Body/Actions/Value.bbcode_text = "%d ([color=%s]%d[/color])" % [actions, color, (actions - base_actions)]
	
func describe(token):
	if token.is_in_group("money_trees"):
		$Body/Label.text = "Money Tree"
		$Body/GPM/Value.text = str(token.gpm)
		$Body/Description.visible = false
		$Body/Stunned.visible = false
		$Body/Range.visible = false
		$Body/Actions.visible = false
		
	elif token.is_in_group("lures"):
		$Body/Label.text = "Lure"
		$Body/GPM/Range.text = str(token.range)
		$Body/Description.visible = false
		$Body/Stunned.visible = false
		$Body/GPM.visible = false
		$Body/Actions.visible = false
		
	elif token.is_in_group("pathfinders"):
		set_action_label(0 if token.stunned else token.get_action_limit(), token.get_base_action_limit())
		$Body/Label.text = token.get_name()
		$Body/Description.text = token.get_description()
		$Body/Stunned.visible = token.stunned
		$Body/GPM.visible = false
		$Body/Range.visible = false
		
