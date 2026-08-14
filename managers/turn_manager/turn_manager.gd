class_name TurnManager
extends Node
## This class controls the turns for the game.
##

signal new_current_player(id: int)


## The ID of each player, in order of turn direction.
var players: Array[int]

##
var this_player_id: int = 1

## The ID of the player whose turn it is.
var current_player_idx: int = 0


## Returns true if it is the players turn.
func my_turn() -> bool:
	return this_player_id == players[current_player_idx]


## Randomise which players turn it is.
@rpc("any_peer", "call_local", "reliable")
func randomise_turn() -> void:
	current_player_idx = randi_range(0, len(players) - 1)
	var current_player_id: int = players[current_player_idx]
	new_current_player.emit(current_player_id)


## Move to the next player.
@rpc("any_peer", "call_local", "reliable")
func next_turn() -> void:
	current_player_idx = (current_player_idx + 1) % len(players)
	var current_player_id: int = players[current_player_idx]
	new_current_player.emit(current_player_id)
