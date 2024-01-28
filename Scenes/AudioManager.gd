extends Node3D
var sound_file_base = ["res://Audio/SoundEffects/Player/Launch/",
"res://Audio/SoundEffects/Player/Slap/",
"res://Audio/SoundEffects/Player/Whoosh/",
"res://Audio/SoundEffects/UI/HUD/",
"res://Audio/SoundEffects/UI/Menu/"]


func _random_sound_container(sound_type : String):
	#TODO make sound_file_base a param
	var randTotalCount : int = dir_sound_max(sound_file_base[1])
	var randSelect : int = randi_range(1,randTotalCount)
	var sound = AudioStreamOggVorbis.load_from_file(sound_file_base[1] + sound_type + str(randSelect) +".ogg")
	#TODO make audioStream a variable
	var audioStream = get_node("Music/AudioStreamPlayer1")
	audioStream.set_stream(sound)
	var randPitch : float = randf_range(-.25,.25) + 1.0
	audioStream.set_pitch_scale(randPitch)
	audioStream.play()
	
func dir_sound_max(path):
	var dir = DirAccess.open(path)
	var count : int = 0
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			file_name = dir.get_next()
			count += 1
	else:
		print("An error occurred when trying to access the path.")
	return count/2
		
func _unhandled_input(event):
	if event is InputEventKey:
		if event.is_pressed() and event.keycode == KEY_F:
			_random_sound_container("test")
	
