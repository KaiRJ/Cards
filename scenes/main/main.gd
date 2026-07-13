extends Control
## TODO
##

@export var deck_scene: PackedScene
@export var player_scene: PackedScene
@export var opponent_scenes: Array[PackedScene]

var deck: Deck

@onready var multiplayer_manager: MultiplayerManager = $MultiplayerManager
@onready var host_button: Button = $HostButton
@onready var join_button: Button = $JoinButton
@onready var start_button: Button = $StartButton


func _ready() -> void:
	host_button.pressed.connect(_on_host_button_pressed)
	join_button.pressed.connect(_on_join_button_pressed)
	start_button.pressed.connect(_on_start_button_pressed)
	start_button.hide()
	
	deck = deck_scene.instantiate()
	add_child(deck)
	deck.hide()


## Set up a shuffled game deck and add it to the scene.
@rpc("any_peer", "call_local")
func setup_deck(new_seed: int) -> void:
	deck.shuffle_deck(new_seed)
	deck.show()


## Set up the player and add them to the scene.
@rpc("any_peer", "call_local")
func setup_player() -> void:
	var player: Player = player_scene.instantiate()
	deck.deal.connect(player._on_dealt_card)
	add_child(player)


## Set up and add the opponent to the scene.
@rpc("any_peer", "call_local")
func setup_opponent(id: int) -> void:
	var opponent: Opponent = opponent_scenes.pop_front().instantiate()
	deck.deal.connect(opponent._on_dealt_card)
	opponent.opponent_id = id
	add_child(opponent)


func _on_host_button_pressed() -> void:
	var error: Error = multiplayer_manager.create_game()
	if (error != OK):
		push_error("Cannot host: " + str(error))
		return
		
	host_button.hide()
	join_button.hide()
	start_button.show()


func _on_join_button_pressed() -> void:
	var error: Error = multiplayer_manager.join_game()
	if (error != OK):
		push_error("Cannot join: " + str(error))
		return

	host_button.hide()
	join_button.hide()


func _on_start_button_pressed() -> void:
		randomize()
		setup_deck.rpc(randi())
		setup_player.rpc()
		
		for id: int in GameManager.players:
			setup_opponent.rpc(id)
