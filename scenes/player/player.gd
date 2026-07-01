class_name Player
extends CanvasLayer
## TODO

## ID for multiplyer actions.
var player_id: int = 0

@onready var hand: HBoxContainer = $Hand


func _ready() -> void:
	# remove the placeholder cards
	for card: Card in hand.get_children():
		card.queue_free()


## Only accepts cards intented for this player.
func _on_dealt_card(id: int, card: Card) -> void:
	if id != player_id:
		return 
	hand.add_child(card)
