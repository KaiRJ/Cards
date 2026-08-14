class_name Golf
extends Control
##

## TODO
@onready var deck: Deck = %Deck

## TODO
@onready var player_spawn_manager: PlayerSpawnManager = %PlayerSpawnManager

## TODO
@onready var turn_manager: TurnManager = %TurnManager


func _ready() -> void:
	# set up game deck
	deck.rng.seed = GameData.game_seed
	deck.shuffle_deck()

	# set up player spawner and spawn all other players
	player_spawn_manager.players = GameData.players
	player_spawn_manager.this_player_id = GameData.this_player_id
	player_spawn_manager.spawn_players()

	# deal cards to each player
	for id: int in GameData.players.keys():
		for _i: int in range(9):
			deck.deal_card(id)

	# set up TurnManager and randomise starting player
	turn_manager.new_current_player.connect(set_label) # label for testing
	turn_manager.players = GameData.players.keys()
	turn_manager.this_player_id = GameData.this_player_id
	turn_manager.randomise_turn()


func set_label(id: int) -> void:
	var player_name: String = GameData.players[id]
	%Label.text = player_name + "'s turn."
