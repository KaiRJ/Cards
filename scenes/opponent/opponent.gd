class_name Opponent
extends Control
## TODO 

## ID for multiplyer actions.
var opponent_id: int = 0

@onready var hand: HBoxContainer = %Hand


func _ready() -> void:
	# remove the placeholder cards
	for card: Card in hand.get_children():
		#card.queue_free()
		pass


## Only accepts cards intented for this opponent.
func _on_dealt_card(id: int, card: Card) -> void:
	if id != opponent_id:
		return 
	hand.add_child(card)
	card.flip_card() # always want these cards face down
	
