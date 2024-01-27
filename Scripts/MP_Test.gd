extends Node3D

var peer = ENetMultiplayerPeer.new()
@export var player : PackedScene
@onready var canvas = $CanvasLayer


func _on_host_pressed():
	print("Hosting Server...")
	peer.create_server(123)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	add_player()
	canvas.hide()
	

func _on_join_pressed():
	print("Joining Server...")
	peer.create_client("127.0.0.1", 123)
	multiplayer.multiplayer_peer = peer
	canvas.hide()
	
func add_player(id = 1):
	var new_player = player.instantiate()
	new_player.name = str(id)
	call_deferred("add_child", new_player)

func exit_game(id):
	multiplayer.peer_disconnected.connect(del_player)
	del_player(id)


func del_player(id):
	rpc("_del_player", id)
	
@rpc("any_peer", "call_local") func _del_player(id):
	get_node(str(id)).queue_free()
