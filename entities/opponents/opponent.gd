class_name Opponent
extends Control
## The opponent scene manages all [Card]s in their [member hand].
## And applies game actions if their ID matches the [member opponent_id].
##

## ID for multiplyer actions.
var opponent_id: int = 0

@onready var hand: HBoxContainer = %Hand
@onready var name_label: Label = %NameLabel


func _ready() -> void:
	# so the label is in right position
	hand.set_custom_minimum_size(Vector2(0, hand.size.y))
	
	# remove the placeholder cards
	for card: Card in hand.get_children():
		card.queue_free()


## Check if the ID exists and use it to also set [member name_label].
func set_id(id: int) -> void:
	if not GameManager.players.has(id):
		push_warning("Opponent ID doesn't exist")
		return
		
	opponent_id = id
	name_label.text = GameManager.players[id]


## Only accepts cards intented for this opponent.
func _on_dealt_card(id: int, card: Card) -> void:
	if id != opponent_id:
		return 
	hand.add_child(card)
	card.flip_card() # always want these cards face down
	
