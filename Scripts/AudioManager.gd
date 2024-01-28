extends Node3D
var sound_file_base = ["res://Audio/SoundEffects/Player/Launch/",
"res://Audio/SoundEffects/Player/Slap/",
"res://Audio/SoundEffects/Player/Whoosh/",
"res://Audio/SoundEffects/UI/HUD/",
"res://Audio/SoundEffects/UI/Menu/"]
var audioStream : AudioStreamPlayer

func _ready():
	audioStream = get_node("Music/AudioStreamPlayer1")
	
func _process(delta):
	if audioStream.is_playing() == false:
		var randTheme = randi_range(1,3)
		var newStream
		if randTheme == 1:
			newStream = load("res://Audio/Music/Music_Segment_ArenaHighIntensity.ogg")
		elif randTheme == 2:
			newStream = load("res://Audio/Music/Music_Segment_ArenaMedIntensity.ogg")
		else:
			newStream = load("res://Audio/Music/Music_Segment_ArenaLowIntensity.ogg")
		audioStream.stream = newStream
		audioStream.play()

func _random_sound_container(sound_type : String):
	#TODO make sound_file_base a param
	var randTotalCount : int = dir_sound_max(sound_file_base[1])
	var randSelect : int = randi_range(1,randTotalCount)
	var path : String = sound_file_base[1] + sound_type + str(randSelect) +".ogg"
	
	var soundscene = load("res://Scenes/SoundEffect.tscn")
	var soundinstance = soundscene.instantiate()
	add_child(soundinstance)
	soundinstance._set_sound(path)
	
	#TODO make audioStream a variable
	
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
		
#func _unhandled_input(event):
#	if event is InputEventKey:
#		if event.is_pressed() and event.keycode == KEY_F:
#			_random_sound_container("test")
#	
