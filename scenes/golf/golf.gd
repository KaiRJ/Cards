class_name Golf
extends Control

@onready var deck: Deck = %Deck
@onready var player: Player = %Player
@onready var opponent_spawn_manager: OpponentSpawnManager = %OpponentSpawnManager
@onready var turn_manager: TurnManager = %TurnManager


func _ready() -> void:
	# set up game deck
	deck.deal.connect(player._on_dealt_card)
	deck.rng.seed = GameData.game_seed
	deck.shuffle_deck()

	# spawn all opponents
	opponent_spawn_manager.spawn_opponents()

	# set up TurnManager and randomise starting player
	turn_manager.new_current_player.connect(set_label) # label for testing
	turn_manager.players = GameData.players.keys()
	turn_manager.rng.seed = GameData.game_seed
	turn_manager.randomise_turn()


func set_label(id: int) -> void:
	var player_name: String = GameData.players[id]
	%Label.text = player_name + "'s turn."
