extends Control
## TODO
##

## 
const PORT: int = 7777

const SERVER_ADDRES: String = "localhost"

@export var deck_scene: PackedScene
@export var player_scene: PackedScene

@onready var host_button: Button = $HostButton
@onready var join_button: Button = $JoinButton

func _ready() -> void:
	host_button.pressed.connect(_on_host_button_pressed)
	join_button.pressed.connect(_on_join_button_pressed)

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


func _on_host_button_pressed() -> void:
	var error: Error = create_game()
	if (error != OK):
		return
		
	_disable_buttons()
	_setup_player()
	


func _on_join_button_pressed() -> void:
	var error: Error = join_game()
	if (error != OK):
		return
		
	_disable_buttons()
	_setup_player()

func _on_peer_connected(_peer_id: int) -> void:
	print("Player joined!")


## Disable and hide all buttons.
func _disable_buttons() -> void:
	host_button.disabled = true
	host_button.visible = false 
	
	join_button.disabled = true
	join_button.visible = false


func _setup_player() -> void:
	var deck: Deck = deck_scene.instantiate()
	add_child(deck)
	
	var player: Player = player_scene.instantiate()
	deck.deal.connect(player._on_dealt_card) # TODO connect variable to signal
	add_child(player)
