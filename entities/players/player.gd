class_name Player
extends Control
## The player scene manages all [Card]s in their [member hand].
## And applies game actions if their ID matches the [member player_id].
##

## ID for multiplyer actions.
var player_id: int = 0

@onready var hand: GridContainer = %Hand
@onready var name_label: Label = %NameLabel


func _ready() -> void:
	# remove the placeholder cards
	for card: Card in hand.get_children():
		card.queue_free()


## Only accepts cards intented for this player.
func _on_dealt_card(id: int, card: Card) -> void:
	if id != player_id:
		return

	hand.add_child(card)
	card.flip_card() # always want these cards face down
