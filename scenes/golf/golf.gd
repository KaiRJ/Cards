class_name Golf
extends Control

@onready var deck: Deck = %Deck
@onready var player: Player = %Player
@onready var opponent_spawn_manager: OpponentSpawnManager = %OpponentSpawnManager

func _ready() -> void:
	deck.deal.connect(player._on_dealt_card)
	deck.shuffle_deck(GameManager.game_seed)
	opponent_spawn_manager.spawn_opponents()
