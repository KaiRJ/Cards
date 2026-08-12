class_name MultiplayerManager
extends Node
## Manages the hosting and joining of players in the game.
##

## TODO
signal player_joined(id: int)

## TODO
@export var PORT: int = 7777

## TODO
@export var DEFAULT_SERVER_IP: String = "localhost"

## TODO
@export var MAX_CONNECTIONS: int = 3 # host doesn't count as a connection


func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)


## Create the game server, and register player using unique ID.
func create_game() -> Error:
	var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	var error: Error = peer.create_server(PORT, MAX_CONNECTIONS)
	if error:
		push_error("Cannot host: " + str(error))
		return error

	multiplayer.multiplayer_peer = peer
	return OK


## Join a game server, and register player using unique ID.
func join_game(address: String = "") -> Error:
	if address.is_empty():
		address = DEFAULT_SERVER_IP

	var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	var error: Error = peer.create_client(address, PORT)
	if error:
		push_error("Cannot join: " + str(error))
		return error

	multiplayer.multiplayer_peer = peer
	return OK


## Called on the server and all clients when a new peer connects.
func _on_peer_connected(_id: int) -> void:
	pass


## Called on the server and clients when a peer disconnects.
func _on_peer_disconnected(id: int) -> void:
	print("Peer Disconnected: " + str(id))


## Called only from clients once they have successfully connected.
func _on_connected_to_server() -> void:
	player_joined.emit(multiplayer.get_unique_id())


## Called only from clients.
func _on_connection_failed(id: int) -> void:
	print("Connection Failed: " + str(id))
