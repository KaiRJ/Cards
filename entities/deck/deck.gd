class_name Deck
extends PanelContainer
## This scene contains all the functionality of a deck of cards for the game.

## Signals for dealing cards to each player.
signal deal(player_id: int, card: Card, facing: Card.Facing)

## Signal for when the deck is selected, whether it's empty or not.
signal deck_selected()

## The card scene
@export var card_scene: PackedScene

## Array to hold all the card [Texture2D]s that make up the deck.
@export var deck: Array[Texture2D]

## TODO
@export var orientation: Card.Facing = Card.Facing.DOWN

## The [RandomNumberGenerator] used for shuffling the deck
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

@onready var top_card: Card = %TopCard

func _ready() -> void:
	top_card.card_selected.connect(_on_deck_selected)
	_sync_deck_and_top_card()


## Update the top card with the next card
func pop_top() -> Card:
	if deck.size() < 1:
		return

	# save current top card and replace it with the next one
	var card_texture: Texture2D = deck.pop_front()
	_sync_deck_and_top_card()

	# create new card scene and return it
	var card: Card = card_scene.instantiate()
	card.initialise_card(card_texture)
	return card


## TODO
func push_top(card: Card) -> void:
	deck.push_front(card.front)
	_sync_deck_and_top_card()


## Shuffle the current deck, using a simple shuffling algorithm.
@rpc("any_peer", "call_local")
func shuffle_deck() -> void:
	if deck.size() < 2:
		return

	for i: int in range(deck.size() - 2):
		# Pick a random index from i to the end of the array
		var j: int = rng.randi_range(i, deck.size() - 1)
		# Swap elements at i and j
		var temp: Texture2D = deck[i]
		deck[i] = deck[j]
		deck[j] = temp


## Emits the deal card signal for a specific player on every peer, including locally.
@rpc("any_peer", "call_local")
func deal_card(player_id: int, face_down: bool = true) -> void:
	if deck.is_empty():
		return

	deal.emit(player_id, pop_top(), face_down)


func _on_deck_selected(_card: Card) -> void:
	deck_selected.emit()


func _sync_deck_and_top_card() -> void:
	if deck.size() < 1:
		top_card.facing(Card.Facing.HIDDEN)
		return

	top_card.initialise_card(deck[0])
	top_card.facing(orientation)
