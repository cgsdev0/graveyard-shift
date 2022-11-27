tool
extends AudioStreamPlayer3D

export(Array, AudioStream) var samples = []
export(String, DIR) var select_samples_from_folder setget load_samples_from_folder
export(int, "Pure", "No consecutive repetition", "Use all samples before repeat") var random_strategy = 0
onready var base_volume = unit_db
export(float, 0, 80) var random_volume_range = 0
onready var base_pitch = pitch_scale
export(float, 0, 4) var random_pitch_range = 0

var playing_sample_nb : int = -1
var last_played_sample_nb : int = -1 # only used if random_strategy = 1
var to_play = [] # only used if random_strategy = 2

# You can use playing_sample_nb to choose what sample to use
func play(from_position=0.0, playing_sample_nb=-1):
	var number_of_samples = len(samples)
	if number_of_samples > 0:
		if playing_sample_nb < 0:
			if number_of_samples == 1:
				playing_sample_nb = 0
			else:
				match random_strategy:
					1:
						playing_sample_nb = randi() % (number_of_samples - 1)
						if last_played_sample_nb == playing_sample_nb:
							playing_sample_nb += 1
						last_played_sample_nb = playing_sample_nb
					2:
						if len(to_play) == 0:
							for i in range(number_of_samples):
								if i != last_played_sample_nb:
									to_play.append(i)
							to_play.shuffle()
						playing_sample_nb = to_play.pop_back()
						last_played_sample_nb = playing_sample_nb
					_:
						playing_sample_nb = randi() % number_of_samples
			if random_volume_range != 0:
				.set_unit_db(base_volume + (randf() - .5) * random_volume_range)
			if random_pitch_range != 0:
				.set_pitch_scale(max(0.0001, base_pitch + (randf() - .5) * random_pitch_range))
		set_stream(samples[playing_sample_nb])
		.play(from_position)

func set_unit_db(new_unit_db):
	.set_unit_db(new_unit_db)
	base_volume = new_unit_db

func set_pitch_scale(new_pitch):
	.set_pitch_scale(max(0.0001, new_pitch))
	base_pitch = new_pitch

func load_samples_from_folder(path):
	if path != "":
		samples.clear()
		var dir = Directory.new()
		if dir.open(path) == OK:
			dir.list_dir_begin(true)
			var file_name = dir.get_next()
			while file_name != "":
				if not dir.current_is_dir() and file_name.ends_with(".import"):
					var resource_path = dir.get_current_dir() + "/" + file_name.replace('.import', '')
					if resource_path.get_extension().to_lower() in ["wav", "ogg"]:
						var resource = load(resource_path)
						if resource != null:
							samples.append(resource)
				file_name = dir.get_next()
		select_samples_from_folder = ""
