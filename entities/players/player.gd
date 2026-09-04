class_name Player
extends Control
## The player scene manages all [Card]s in their [member hand].
## And applies game actions if their ID matches the [member player_id].
##

## TODO
signal card_selected(player_id: int, card_idx: int)

## ID for multiplyer actions.
var player_id: int = 0

## TODO
var cards: Array[Card] = []

@onready var hand: GridContainer = %Hand
@onready var name_label: Label = %NameLabel


func _ready() -> void:
	# remove the placeholder cards
	for card: Card in hand.get_children():
		card.queue_free()


## Only accepts cards intented for this player.
func _on_dealt_card(id: int, card: Card, orientation: Card.Facing) -> void:
	if id != player_id:
		return

	cards.append(card)
	hand.add_child(card)

	# TODO create a function in the turn manager for this?
	if multiplayer.get_unique_id() == player_id:
		card.card_selected.connect(_on_card_selected)
	else:
		card.button.hide()

	card.facing(orientation)


func _on_card_selected(card: Card) -> void:
	card_selected.emit(player_id, cards.find(card))
