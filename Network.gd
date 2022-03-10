extends Node

var username = ""

var main = "res://Main.tscn"


func _ready():
	get_tree().connect("network_peer_connected", self, "_on_network_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_on_network_peer_disconnected")
	get_tree().connect("connected_to_server", self, "_on_connected_to_server")
	get_tree().connect("server_disconnected", self, "_on_server_disconnected")

func create_server(username_chosen):
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(4242, 32)
	get_tree().set_network_peer(peer)
	
	#AudioServer.set_bus_mute(0, true) # The server mutes the game
	username = username_chosen + " (host)"	


func join_server(to_ip, username_chosen):
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(to_ip, 4242)
	get_tree().set_network_peer(peer)
	
	username = username_chosen
		# If a server is detected call _on_connected_to_server() to load the game

func get_IP():
	for ip in IP.get_local_addresses():
		if ip.begins_with("192.168."):
			return ip

func _on_network_peer_disconnected(id):
	if id != 1:
		get_tree().get_root().find_node(str(id), true, false).queue_free()

func _on_connected_to_server():
	$Menu/Label2.text += "client_connected \n"

func _on_server_disconnected():
	$Menu/Label2.text += "server disconnected \n"
	get_tree().set_network_peer(null)
