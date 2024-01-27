extends Node

var player:Node
var camera:Camera3D
var player_roster : Dictionary = {}

func set_player(player_node):
	player = player_node
	print(player)

func set_camera(camera_node):
	camera = camera_node
	print(camera)
	
#func add_to_roster(id : String, player : Node):
	#if multiplayer.get_network_connected_peers() < 4:
		#player_roster.
