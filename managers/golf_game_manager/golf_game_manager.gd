class_name GolfGameManager
extends Node
##

enum Select {PLAYER_CARD, DECK_CARD, BIN_CARD}

## The [TurnManager] for the game.
@export var turn_manager: TurnManager

## The [PlayerManager] for the game.
@export var player_manager: PlayerManager

## The [Deck] for the game.
@export var deck: Deck

## The bin [Deck] for the game.
@export var bin: Deck

##
var player_card: Card

## The order the player has selected cards. This is used to decide what to do.
var selection_order: Array[Select] = []


## Each time a game move is made this function
@rpc("any_peer", "call_local", "reliable")
func run_state_machine() -> void:
	print(selection_order)

	var turn_complete: bool = false

	if selection_order == [Select.PLAYER_CARD]:
		if player_card.is_facing(Card.Facing.UP):
			reset()
			return

		player_card.flip()
		turn_complete = true

	elif selection_order == [Select.DECK_CARD]:
		deck.top_card.flip()

	elif selection_order == [Select.DECK_CARD, Select.PLAYER_CARD]:
		bin.push_top(player_card)
		var deck_card: Card = deck.pop_top()
		player_card.copy_from_card(deck_card)
		player_card.facing(Card.Facing.UP)
		turn_complete = true

	elif selection_order == [Select.DECK_CARD, Select.BIN_CARD]:
		var deck_card: Card = deck.pop_top()
		bin.push_top(deck_card)
		turn_complete = true

	elif selection_order == [Select.BIN_CARD, Select.PLAYER_CARD]:
		var temp_bin_card: Card = bin.pop_top()
		bin.push_top(player_card)
		player_card.copy_from_card(temp_bin_card)
		player_card.facing(Card.Facing.UP)
		turn_complete = true

	if turn_complete:
		reset()
		turn_manager.next_turn()


func reset() -> void:
	player_card = null
	selection_order = []


## TODO
@rpc("any_peer", "call_local", "reliable")
func select_card(player_id: int, card_idx: int) -> void:
	# can only select one card at a time
	if player_card != null:
		return

	selection_order.append(Select.PLAYER_CARD)
	player_card = player_manager.get_player_card(player_id, card_idx)
	run_state_machine()


## TODO
@rpc("any_peer", "call_local", "reliable")
func select_deck() -> void:
	if deck.deck.is_empty():
		return

	selection_order.append(Select.DECK_CARD)
	run_state_machine()


## TODO
@rpc("any_peer", "call_local", "reliable")
func select_bin() -> void:
	# unselect bin card
	if selection_order == [Select.BIN_CARD]:
		reset()
		return

	selection_order.append(Select.BIN_CARD)
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


func _on_bin_card_selected() -> void:
	if not turn_manager.my_turn():
		return

	select_bin.rpc()
