extends Node
## TODO

signal player_connected(peer_id: int)

const PORT: int = 7777
const DEFAULT_SERVER_IP: String = "localhost"
const MAX_CONNECTIONS: int = 1

var rng: RandomNumberGenerator


func _ready() -> void:
	var _connected: int = multiplayer.peer_connected.connect(_on_peer_connected)
	
	rng = RandomNumberGenerator.new()
	
	

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


## When a peer connects, send them host info and send RNG.
func _on_peer_connected(id: int) -> void:
	# seed rng seed to new player
	if multiplayer.is_server():
		_register_rng.rpc_id(id, rng.seed)
	
	_register_player.rpc_id(id)


@rpc("any_peer", "reliable")
func _register_player() -> void:
	var new_player_id: int = multiplayer.get_remote_sender_id()
	print("Registering player: " + str(new_player_id))
	player_connected.emit(new_player_id)


@rpc("any_peer", "reliable")
func _register_rng(s: int) -> void:
	print("Registering RNG: " + str(s))
	rng.seed = s
