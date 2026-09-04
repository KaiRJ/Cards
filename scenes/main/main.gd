extends Control

@onready var deck: Deck = %Deck
@onready var bin: Deck = %Bin
@onready var player_manager: PlayerManager = %PlayerManager
@onready var turn_manager: TurnManager = %TurnManager
@onready var game_manager: GolfGameManager = %GolfGameManager


func _ready() -> void:
	# set up game deck
	deck.deck_selected.connect(game_manager._on_deck_card_selected)
	deck.rng.seed = GameData.game_seed
	deck.shuffle_deck()

	# set up bin deck
	bin.deck_selected.connect(game_manager._on_bin_card_selected)
	bin.rng.seed = GameData.game_seed

	# set up player spawner and spawn all other players
	player_manager.card_selected.connect(game_manager._on_player_card_selected)
	player_manager.this_player_id = GameData.this_player_id
	player_manager.spawn_players(GameData.players)

	# set up TurnManager and randomise starting player
	turn_manager.new_current_player.connect(set_label) # label for testing
	turn_manager.players = GameData.players.keys()
	turn_manager.this_player_id = GameData.this_player_id
	turn_manager.randomise_turn()

	# deal cards to each player
	# TODO move to Hand scene, or game manager?
	for id: int in GameData.players.keys():
		for _i: int in range(9):
			deck.deal_card(id, true)


func set_label(id: int) -> void:
	var player_name: String = GameData.players[id]
	%Label.text = player_name + "'s turn."
