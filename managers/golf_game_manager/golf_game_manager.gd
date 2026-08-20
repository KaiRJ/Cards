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

##
var deck_card: Card

##
var bin_card: Card

## The order the player has selected cards. This is used to decide what to do.
var selection_order: Array[Select] = []


## Each time a game move is made this function
@rpc("any_peer", "call_local", "reliable")
func run_state_machine() -> void:
	var turn_complete: bool = false

	if selection_order == [Select.PLAYER_CARD]:
		player_card.flip_card()
		turn_complete = true

	elif selection_order == [Select.DECK_CARD]:
		deck.texture = deck_card.front

	elif selection_order == [Select.DECK_CARD, Select.PLAYER_CARD]:
		var temp_card: Card = Card.new()
		temp_card.replace_card(player_card)
		player_card.replace_card(deck_card)
		deck_card.replace_card(temp_card)
		deck.texture = temp_card.back
		turn_complete = true

	elif selection_order == [Select.DECK_CARD, Select.BIN_CARD]:
		print("wroking ")
		bin.deck.push_front(bin_card)
		bin.deck.push_front(deck_card)
		bin.texture = deck_card.front
		deck.texture = deck.back_texture
		turn_complete = true

	elif selection_order == [Select.BIN_CARD, Select.PLAYER_CARD]:
		var temp_card: Card = Card.new()
		temp_card.replace_card(player_card)
		player_card.replace_card(bin_card)
		bin_card.replace_card(temp_card)
		bin.texture = bin_card.front
		turn_complete = true

	if turn_complete:
		reset()
		turn_manager.next_turn()


func reset() -> void:
	player_card = null
	deck_card = null
	bin_card = null
	selection_order = []


## TODO
@rpc("any_peer", "call_local", "reliable")
func select_card(player_id: int, card_idx: int) -> void:
	if player_card:
		return

	var new_player_card: Card = player_manager.get_player_card(player_id, card_idx)
	if new_player_card.texture == new_player_card.front:
		return

	selection_order.append(Select.PLAYER_CARD)
	player_card = new_player_card
	print(player_card)
	print(new_player_card)
	run_state_machine()


## TODO
@rpc("any_peer", "call_local", "reliable")
func select_deck() -> void:
	if deck_card:
		return

	if deck.deck.is_empty():
		return

	selection_order.append(Select.DECK_CARD)
	deck_card = deck.deck.pop_front()
	run_state_machine()


## TODO
@rpc("any_peer", "call_local", "reliable")
func select_bin() -> void:
	if bin_card:
		return

	if not bin.deck.is_empty():
		bin_card = bin.deck.pop_front()

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
