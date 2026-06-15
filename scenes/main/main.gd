extends Control
## TODO
##

@export var deck_scene: PackedScene
@export var player_scene: PackedScene

@onready var host_button: Button = $HostButton
@onready var join_button: Button = $JoinButton

func _ready() -> void:
	var _host: int = host_button.pressed.connect(_on_host_button_pressed)
	var _join: int = join_button.pressed.connect(_on_join_button_pressed)


func _on_host_button_pressed() -> void:
	if (Multiplayer.create_game() != OK):
		return
		
	_disable_buttons()
	_setup_player()
	


func _on_join_button_pressed() -> void:
	if (Multiplayer.join_game() != OK):
		return
		
	_disable_buttons()
	_setup_player()


## Disable and hide all buttons.
func _disable_buttons() -> void:
	host_button.disabled = true
	host_button.visible = false 
	
	join_button.disabled = true
	join_button.visible = false


## Set up the player's deck.
func _setup_player() -> void:
	var deck: Deck = deck_scene.instantiate()
	add_child(deck)
	
	var player: Player = player_scene.instantiate()
	var _deck: int = deck.deal.connect(player._on_dealt_card)
	add_child(player)
