class_name MultiplayerManager
extends Node
## Manages the hosting and joining of players in the game.
##

@export var PORT: int = 7777
@export var DEFAULT_SERVER_IP: String = "localhost"
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
		return error

	multiplayer.multiplayer_peer = peer
	return OK


## Called on the server and all clients when a new peer connects.
## Send new peer data to previously connected peers. New peer also gets previous peer data.
func _on_peer_connected(id: int) -> void:
	GameManager.set_player.rpc_id(id, multiplayer.get_unique_id(), GameManager.players[multiplayer.get_unique_id()])
	
	if multiplayer.get_unique_id():
		GameManager.set_game_seed.rpc_id(id, GameManager.game_seed)
		
	print("Peer Connected: " + str(id))


## Called on the server and clients when a peer disconnects.
func _on_peer_disconnected(id: int) -> void:
	print("Peer Disconnected: " + str(id))


## Called only from clients.
func _on_connected_to_server() -> void:
	pass


## Called only from clients.
func _on_connection_failed(id: int) -> void:
	print("Connection Failed: " + str(id))
