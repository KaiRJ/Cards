class_name MultiplayerManager
extends Node
## Manages the hosting and joining of players in the game.
##

@export var PORT: int = 7777
@export var DEFAULT_SERVER_IP: String = "localhost"
@export var MAX_CONNECTIONS: int = 3 # host doesn't count as a connection

var player_name: String = "Player"


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
	GameData.register_player(multiplayer.get_unique_id(), player_name)
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


## Send the game seed and register all players on each client.
func send_game_data_to_clients() -> void:
	GameData.set_game_seed.rpc(GameData.game_seed)

	for id: int in GameData.players:
		GameData.register_player.rpc(id, GameData.players[id])


## Called on the server and all clients when a new peer connects.
func _on_peer_connected(_id: int) -> void:
	pass


## Called on the server and clients when a peer disconnects.
func _on_peer_disconnected(id: int) -> void:
	print("Peer Disconnected: " + str(id))


## Called only from clients to register themselves with the server, once they
## have successfully connected.
func _on_connected_to_server() -> void:
	var player_id: int = multiplayer.get_unique_id()
	GameData.register_player.rpc_id(1, player_id, player_name)
	print("Registing " + player_name + " with ID " + str(player_id))


## Called only from clients.
func _on_connection_failed(id: int) -> void:
	print("Connection Failed: " + str(id))
