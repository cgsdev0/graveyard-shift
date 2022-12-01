extends Node

enum Line {
	WELCOME,
	OVERVIEW,
	OOPS,
	ADVENTURER,
}
const lines = {
	Line.WELCOME: {
		"delay": 1.0,
		"text": [
			"welcome to the [wave]GRAVEYARD SHIFT[/wave]...",
			"first day? well, the job is simple! we work through the night to prevent monsters from their only goal:",
			{ "clear": false, "text": " escaping the graveyard and wreaking havoc on society!" },
		],
	},
	Line.OVERVIEW: {
		"text": [
			"each turn, you will be dealt up to 4 cards.",
			"you can spend 2 actions per turn. they will not carry over.",
			"when you end your turn, the monster will move towards the exit.\nyou can hover over a monster to learn more about it.",
			"good luck!",
		],
	},
	Line.OOPS: {
		"text": [
			"woops! that wall doesn't actually block the monster's path. try to be more careful!",
		],
	},
	Line.ADVENTURER: {
		"text": [
			"some graveyards have treasure! this often attracts adventurers.",
			"if you help an adventurer recover treasure and escape the graveyard, they will share the rewards with you!",
		],
	},
}

var played_lines = {}

var in_dialogue = false

func trigger_line(line) -> void:
	if played_lines.has(line):
		call_deferred("emit_signal", "dialogue_finished", line)
		return
	played_lines[line] = true
	call_deferred("emit_signal", "dialogue", line, lines[line])
	
signal dialogue(data)

signal dialogue_finished(line)

func on_hard_reset():
	in_dialogue = false
	
func _ready():
	Game.connect("hard_reset", self, "on_hard_reset")
