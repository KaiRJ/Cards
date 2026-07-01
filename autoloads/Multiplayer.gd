extends Node
## TODO

const PORT: int = 7777
const DEFAULT_SERVER_IP: String = "localhost"
const MAX_CONNECTIONS: int = 4


## TODO
func create_game() -> Error:
	var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	var error: Error = peer.create_server(PORT, MAX_CONNECTIONS)
	if error:
		return error		
	multiplayer.multiplayer_peer = peer
	
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
	
	return OK
