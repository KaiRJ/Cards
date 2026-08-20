class_name Deck
extends TextureRect
## This scene contains all the functionality of a deck of cards for the game.

## Signals for dealing cards to each player.
signal deal(player_id: int, card: Card)

## TODO
signal deck_selected()

## The card scene
@export var card_scene: PackedScene

## Array to hold all the card textures that make up the deck.
@export var card_textures: Array[Texture2D]

## TODO
@export var back_texture: Texture2D

## Array to hold all the [Card]s currently in the [param deck].
var deck: Array[Card]

## The [RandomNumberGenerator] used for shuffling the deck
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

@onready var select_button: Button = %SelectButton

func _ready() -> void:
	select_button.pressed.connect(_on_button_pressed)

	texture = null # remove default
	select_button.custom_minimum_size = back_texture.get_size()



## Create a new deck of [Card]s based on the textures in [param card_textures].
func create_deck() -> void:
	texture = back_texture

	for front_texture: Texture2D in card_textures:
		var card: Card = card_scene.instantiate()
		card.setup_card(front_texture, back_texture)
		deck.push_back(card)


## Shuffle the current deck, using a simple shuffling algorithm.
@rpc("any_peer", "call_local")
func shuffle_deck() -> void:
	for i: int in range(deck.size() - 2):
		# Pick a random index from i to the end of the array
		var j: int = rng.randi_range(i, deck.size() - 1)
		# Swap elements at i and j
		var temp: Card = deck[i]
		deck[i] = deck[j]
		deck[j] = temp


## Emits the deal card signal for a specific player on every peer, including locally.
@rpc("any_peer", "call_local")
func deal_card(player_id: int) -> void:
	if deck.is_empty():
		return

	var card: Card = deck.pop_front()
	deal.emit(player_id, card)

	if deck.is_empty():
		texture = null


## If a card is a available, deal it to the player that picked it.
func _on_button_pressed() -> void:
	deck_selected.emit()
