extends Node
 
## TODO Subject to change
const PORT: int = 7777
const SERVER_ADDRES: String = "localhost"


## TODO
func create_game() -> Error:
	var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	var error: Error = peer.create_server(PORT)
	if error:
		return error
		
	multiplayer.peer_connected.connect(_on_peer_connected)
	
	multiplayer.multiplayer_peer = peer
	return OK


## TODO
func join_game() -> Error:
	var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	var error: Error = peer.create_client(SERVER_ADDRES, PORT)
	if error:
		return error

	multiplayer.multiplayer_peer = peer
	return OK
	

func _on_peer_connected(_peer_id: int) -> void:
	print("Player joined!")
