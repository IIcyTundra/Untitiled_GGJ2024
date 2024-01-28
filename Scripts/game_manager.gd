extends Node

var player:Node
var camera:Camera3D

signal round_started
signal round_ended


func set_player(player_node):
	player = player_node
	print(player)

func set_camera(camera_node):
	camera = camera_node
	print(camera)
	
	


