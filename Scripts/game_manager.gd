extends Node

var player1:Node
var player2:Node
var camera:Camera3D

signal round_started
signal round_ended


func set_player1(player_node):
	player1 = player_node
	print(player1)

func set_player2(player_node):
	player2 = player_node
	print(player2)

func set_camera(camera_node):
	camera = camera_node
	print(camera)



# Called when the player loses health
func lose_health(health : int):
	health -= 1
	health = clamp(health, 0, 3)  # Ensure health doesn't go below 0 or above MAX_HEALTH
	return health
	
	#if health <= 0:
		#die()


func win_game():
	# You can implement additional logic here, such as showing a victory screen, playing a win animation, etc.
	print("Player has won the game!")



