class_name Deck
extends CanvasLayer
## This scene contains all the functionality of a deck of cards.

## Signals for dealing cards to each player.
signal deal(player_id: int, card: Card)

## The card scene
@export var card_scene: PackedScene

## Array to hold all the card textures that make up the deck.
@export var card_textures: Array[Texture2D]

## Array to hold all the cards currently in the deck.
var deck: Array[Card]

## The texture used for the top of the deck and the back of all cards.
@onready var top_card: TextureRect = $TopCard


func _ready() -> void:
	create_deck()
	shuffle_deck()


## Create a new deck of cards.
func create_deck() -> void:
	for face: Texture2D in card_textures:
		var card: Card = card_scene.instantiate()
		card.setup_card(face, top_card.texture)
		deck.push_back(card)


## Shuffle the current deck.
func shuffle_deck() -> void:
	# TODO Set seed of shuffle and call when player connects.
	deck.shuffle()
	

## Emits the deal card signal for a specific player.
@rpc("any_peer")
func deal_card(player_id: int) -> void:
	var card: Card = deck.pop_front()
	deal.emit(player_id, card)


func _on_button_pressed() -> void:
	if deck.is_empty():
		return
		
	# emit deal card signal on all peers for a specific player
	var player_id: int = multiplayer.get_unique_id()
	deal_card(player_id)
	deal_card.rpc(player_id)
