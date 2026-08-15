class_name GolfGameManager
extends Node
##

## The [TurnManager] for the game.
@export var turn_manager: TurnManager

## The [PlayerManager] for the game.
@export var player_manager: PlayerManager

##
var selected_card: Dictionary[String, int] = {
	"player_id": 0,
	"card_idx": 0}


## Each time a game move is made this function
func run_state_machine() -> void:
	print("running state machine")

	if selected_card:
		player_manager.flip_players_card.rpc(
			selected_card["player_id"],
			selected_card["card_idx"])

		turn_manager.next_turn.rpc()


##
func _on_card_selected(player_id: int, card_idx: int) -> void:
	if not turn_manager.my_turn():
		return

	if selected_card:
		pass

	selected_card["player_id"] = player_id
	selected_card["card_idx"] = card_idx

	run_state_machine()
