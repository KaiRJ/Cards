class_name Player
extends Control
## The player scene manages all [Card]s in their [member hand].
## And applies game actions if their ID matches the [member player_id].
##

@onready var hand: HBoxContainer = %Hand
@onready var name_label: Label = %NameLabel


func _ready() -> void:
	# remove the placeholder cards
	for card: Card in hand.get_children():
		card.queue_free()


## Only accepts cards intended for this player.
func _on_dealt_card(id: int, card: Card) -> void:
	print("dealing to " + str(id))
	if id != multiplayer.get_unique_id():
		return
	hand.add_child(card)
