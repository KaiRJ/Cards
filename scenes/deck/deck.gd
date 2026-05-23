class_name Deck
extends Control
## This scene contains all the functionality of a deck of cards.

## The card scene
@export var card_scene: PackedScene

## Array to hold all the card textures that make up the deck.
@export var card_textures: Array[Texture2D]

@onready var top_card: TextureRect = $TopCard

## Array to hold all the cards currently in the deck.
var deck: Array[Card]

func _ready() -> void:
	create_deck()
	shuffle_deck()


## Create a new deck of cards
func create_deck() -> void:
	for face in card_textures:
		var card: Card = card_scene.instantiate()
		card.setup_card(face, top_card.texture)
		deck.push_back(card)


## Shuffle the current deck.
func shuffle_deck() -> void:
	deck.shuffle()
