class_name Golf
extends Control

@onready var deck: Deck = %Deck
@onready var player: Player = %Player
@onready var player_spawn_manager: PlayerSpawnManager = %PlayerSpawnManager
@onready var turn_manager: TurnManager = %TurnManager


func _ready() -> void:
	# set up game deck
	deck.deal.connect(player._on_dealt_card)
	deck.rng.seed = GameData.game_seed
	deck.shuffle_deck()

	# set up this player
	player.name_label.text = GameData.players[multiplayer.get_unique_id()]

	# spawn all other players
	player_spawn_manager.players = GameData.players
	player_spawn_manager.spawn_players()

	# deal cards to each player
	for id: int in GameData.players.keys():
		for _i: int in range(9):
			deck.deal_card(id)

	# set up TurnManager and randomise starting player
	turn_manager.new_current_player.connect(set_label) # label for testing
	turn_manager.players = GameData.players.keys()
	turn_manager.randomise_turn()


func set_label(id: int) -> void:
	var player_name: String = GameData.players[id]
	%Label.text = player_name + "'s turn."
