class_name Player
extends Control
## TODO

## The unique identifier for a specific player.
@export var player_id: int

@onready var hand: HBoxContainer = $Hand


func _ready() -> void:
	# remove the placeholder cards
	for card in hand.get_children():
		card.queue_free()


func _on_dealt_card(card: Card) -> void:
	hand.add_child(card)
