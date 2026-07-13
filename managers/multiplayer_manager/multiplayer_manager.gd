class_name MultiplayerManager
extends Node
## TODO

@export var PORT: int = 7777
@export var DEFAULT_SERVER_IP: String = "localhost"
@export var MAX_CONNECTIONS: int = 3 # host doesn't count as a connection


func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)


## TODO
func create_game() -> Error:
	var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	var error: Error = peer.create_server(PORT, MAX_CONNECTIONS)
	if error:
		return error
		
	multiplayer.multiplayer_peer = peer
	_register_player(multiplayer.get_unique_id(), "")
	return OK


## TODO
func join_game(address: String = "") -> Error:
	if address.is_empty():
		address = DEFAULT_SERVER_IP
		
	var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	var error: Error = peer.create_client(address, PORT)
	if error:
		return error

	multiplayer.multiplayer_peer = peer
	_register_player(multiplayer.get_unique_id(), "")
	return OK


# TODO
@rpc("any_peer", "reliable")
func _register_player(player_id: int, player_name: String) -> void:
	GameManager.players[player_id] = player_name


## Called on the server and clients when a peer connects, 
## send new peer data to previously connected peers.
func _on_peer_connected(id: int) -> void:
	_register_player.rpc_id(id, multiplayer.get_unique_id(), "")
	print("Peer Connected: " + str(id))


## Called on the server and clients when a peer disconnects.
func _on_peer_disconnected(id: int) -> void:
	print("Peer Disconnected: " + str(id))


## Called only from clients.
func _on_connected_to_server(_id: int) -> void:
	pass


## Called only from clients.
func _on_connection_failed(id: int) -> void:
	print("Connection Failed: " + str(id))
