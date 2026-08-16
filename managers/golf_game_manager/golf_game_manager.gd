class_name GolfGameManager
extends Node
##

enum Select {PLAYER_CARD, DECK_CARD, BIN_CARD}

## The [TurnManager] for the game.
@export var turn_manager: TurnManager

## The [PlayerManager] for the game.
@export var player_manager: PlayerManager

## The [Deck] for the game
@export var deck: Deck

##
var player_card: Card

##
var deck_card: Card

## The order the player has selected cards. This is used to decide what to do.
var selection_order: Array[Select] = []


## Each time a game move is made this function
@rpc("any_peer", "call_local", "reliable")
func run_state_machine() -> void:
	print("running state machine")
	print(selection_order)

	var turn_complete: bool = false
	if selection_order == [Select.PLAYER_CARD]:
		print("flip card")
		player_card.flip_card()
		turn_complete = true

	elif selection_order == [Select.DECK_CARD]:
		deck.top_card.texture = deck_card.front

	elif selection_order == [Select.DECK_CARD, Select.PLAYER_CARD]:
		var temp_card: Card = Card.new()
		temp_card.replace_card(player_card)
		player_card.replace_card(deck_card)
		deck_card.replace_card(temp_card)
		deck.top_card.texture = temp_card.back
		turn_complete = true

	if turn_complete:
		reset()
		turn_manager.next_turn()


func reset() -> void:
	player_card = null
	deck_card = null
	selection_order = []


## TODO
@rpc("any_peer", "call_local", "reliable")
func select_card(player_id: int, card_idx: int) -> void:
	if player_card:
		return

	player_card = player_manager.get_player_card(player_id, card_idx)

	selection_order.append(Select.PLAYER_CARD)
	run_state_machine()


## TODO
@rpc("any_peer", "call_local", "reliable")
func select_deck() -> void:
	if deck_card:
		return

	deck_card = deck.deck.pop_front()

	selection_order.append(Select.DECK_CARD)
	run_state_machine()


##
func _on_player_card_selected(player_id: int, card_idx: int) -> void:
	if not turn_manager.my_turn():
		return

	select_card.rpc(player_id, card_idx)


func _on_deck_card_selected() -> void:
	if not turn_manager.my_turn():
		return

	select_deck.rpc()
