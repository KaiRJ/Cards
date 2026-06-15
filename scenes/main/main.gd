extends Control
## TODO
##

@export var deck_scene: PackedScene
@export var player_scene: PackedScene
@export var opponent_scene: PackedScene

@onready var host_button: Button = $HostButton
@onready var join_button: Button = $JoinButton

func _ready() -> void:
	var _host: int = host_button.pressed.connect(_on_host_button_pressed)
	var _join: int = join_button.pressed.connect(_on_join_button_pressed)


func _on_host_button_pressed() -> void:
	if (Multiplayer.create_game() != OK):
		return
		
	_disable_buttons()
	_setup_game()


func _on_join_button_pressed() -> void:
	if (Multiplayer.join_game() != OK):
		return
		
	_disable_buttons()
	_setup_game()


## Disable and hide all buttons.
func _disable_buttons() -> void:
	host_button.disabled = true
	host_button.visible = false 
	
	join_button.disabled = true
	join_button.visible = false


## Setup the game deck, the player, and each opponent.
func _setup_game() -> void:
	var deck: Deck = _setup_deck()
	_setup_player(deck)
	_setup_opponent(deck)


## Add the game deck to the scene
func _setup_deck() -> Deck:
	var deck: Deck = deck_scene.instantiate()
	add_child(deck)
	return deck


## Set up the player.
func _setup_player(deck: Deck) -> void:
	var player: Player = player_scene.instantiate()
	var _delt: int = deck.deal.connect(player._on_dealt_card)
	add_child(player)


## Set up the opponent.
func _setup_opponent(deck: Deck) -> void:
	var opponent: Opponent = opponent_scene.instantiate()
	var _delt: int = deck.deal.connect(opponent._on_dealt_card)
	add_child(opponent)
