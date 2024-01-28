extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	dir_contents("res://Audio/Music/bacon") # Replace with function body.

	
func _random_ambience_container():
	pass
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
