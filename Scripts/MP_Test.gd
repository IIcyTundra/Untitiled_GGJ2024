extends Node3D

var peer = ENetMultiplayerPeer.new()
@export var player : PackedScene
@onready var main_menu = $MainMenu/PanelContainer
@onready var address_entry = $MainMenu/PanelContainer/MarginContainer/VBoxContainer/Address

const Player = preload("res://Scenes/Player.tscn")
const PORT = 9999

func _on_host_pressed():
	main_menu.hide()
	#hud.show()
	
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	
	add_player(multiplayer.get_unique_id())
	
	upnp_setup()
	

func _on_join_button_pressed():
	main_menu.hide()
	#hud.show()
	
	peer.create_client(address_entry.text, PORT)
	multiplayer.multiplayer_peer = peer

func add_player(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	add_child(player)
	if player.is_multiplayer_authority():
		player.health_changed.connect(update_health_bar)

func remove_player(peer_id):
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()

func update_health_bar(health_value):
	#                                             health_bar.value = health_value
	print("Updated Health")

func _on_multiplayer_spawner_spawned(node):
	if node.is_multiplayer_authority():
		node.health_changed.connect(update_health_bar)
	
func upnp_setup():
	var upnp = UPNP.new()
	
	var discover_result = upnp.discover()
	assert(discover_result == UPNP.UPNP_RESULT_SUCCESS, \
		"UPNP Discover Failed! Error %s" % discover_result)

	assert(upnp.get_gateway() and upnp.get_gateway().is_valid_gateway(), \
		"UPNP Invalid Gateway!")

	var map_result = upnp.add_port_mapping(PORT)
	assert(map_result == UPNP.UPNP_RESULT_SUCCESS, \
		"UPNP Port Mapping Failed! Error %s" % map_result)
	
	print("Success! Join Address: %s" % upnp.query_external_address())