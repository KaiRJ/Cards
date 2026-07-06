extends Control
## TODO
##

@export var deck_scene: PackedScene
@export var player_scene: PackedScene
@export var opponent_scene: PackedScene

var deck: Deck 

@onready var host_button: Button = $HostButton
@onready var join_button: Button = $JoinButton


func _ready() -> void:
	var _host: int = host_button.pressed.connect(_on_host_button_pressed)
	var _join: int = join_button.pressed.connect(_on_join_button_pressed)
	var _connected: int = Multiplayer.player_connected.connect(_on_player_connected)

	_setup_deck()
	deck.hide()

func _on_host_button_pressed() -> void:
	if (Multiplayer.create_game() != OK):
		return
	_disable_buttons()
	deck.show()
	_setup_player()


func _on_join_button_pressed() -> void:
	if (Multiplayer.join_game() != OK):
		return
	_disable_buttons()
	deck.show()
	_setup_player()


func _on_player_connected(id: int) -> void:
	_setup_opponent(id)


## Disable and hide all buttons.
func _disable_buttons() -> void:
	host_button.disabled = true
	host_button.visible = false 
	
	join_button.disabled = true
	join_button.visible = false


## Set up the game deck and add it to the scene.
func _setup_deck() -> void:
	deck = deck_scene.instantiate()
	add_child(deck)


## Set up the player and add them to the scene.
func _setup_player() -> void:
	var player: Player = player_scene.instantiate()
	
	var id: int = multiplayer.get_unique_id()
	player.player_id = id
	
	var _delt: int = deck.deal.connect(player._on_dealt_card)
	
	add_child(player)


## Set up and add the opponent to the scene.
func _setup_opponent(id: int) -> void:
	var opponent: Opponent = opponent_scene.instantiate()
	opponent.opponent_id = id
	
	var _delt: int = deck.deal.connect(opponent._on_dealt_card)
	
	add_child(opponent)
