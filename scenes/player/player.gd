class_name Player
extends CanvasLayer
## TODO

@onready var hand: HBoxContainer = $Hand


func _ready() -> void:
	# remove the placeholder cards
	for card: Card in hand.get_children():
		card.queue_free()


func _on_dealt_card(card: Card) -> void:
	hand.add_child(card)
