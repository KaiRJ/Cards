class_name Player
extends CanvasLayer
## The player scene manages all [Card]s in their [member hand].
## And applies game actions if their ID matches the [member player_id].
##

## ID for multiplyer actions.
var player_id: int = 0

@onready var hand: HBoxContainer = %Hand
@onready var name_label: Label = %NameLabel


func _ready() -> void:
	player_id = multiplayer.get_unique_id()
	if not GameManager.players.has(player_id):
		push_warning("Opponent ID doesn't exist")
	else:
		name_label.text = GameManager.players[player_id]
	
	# remove the placeholder cards
	for card: Card in hand.get_children():
		card.queue_free()


## Only accepts cards intented for this player.
func _on_dealt_card(id: int, card: Card) -> void:
	print("dealing to " + str(id))
	if id != player_id:
		return 
	hand.add_child(card)
