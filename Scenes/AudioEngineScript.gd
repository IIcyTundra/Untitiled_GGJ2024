extends Node3D

var time_of_day
var ambience1 : AudioStreamPlayer
var ambience2 : AudioStreamPlayer
var offset : float = 8.0

var length_of_ambience : float

func _ready():
	time_of_day = get_node("Main").time_of_day
	ambience1 = get_node("Ambience1")
	ambience2 = get_node("Ambience2")
	DirAccess
	ambience1.stream
	
	if time_of_day == get_node("Main").TIME_OF_DAY.dawn:
		length_of_ambience = 44.0
	else:
		length_of_ambience = 8.0
	
func _process(delta):
	pass
	
func _random_ambience_container():
	dir_contents("res://Sounds/ambience/day/")
func dir_contents(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
