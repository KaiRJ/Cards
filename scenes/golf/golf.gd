class_name Golf
extends Control

@export var opponent_scenes: Array[PackedScene]

@onready var deck: Deck = %Deck
@onready var player: Player = %Player


func _ready() -> void:
	deck.deal.connect(player._on_dealt_card)
	deck.shuffle_deck(GameManager.game_seed)

	# setup each opponent
	for id: int in GameManager.players:
		if id != multiplayer.get_unique_id():
			setup_opponent(id)


## Set up and add the opponent to the scene.
func setup_opponent(id: int) -> void:
	var opponent_scene: PackedScene = opponent_scenes.pop_front()
	var opponent: Opponent = opponent_scene.instantiate()
	deck.deal.connect(opponent._on_dealt_card)
	add_child(opponent)
	opponent.set_id(id)
