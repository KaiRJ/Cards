extends Node
## Autoload used to store persistant data during the game.
##

## The seed used to sycronise games between players.
var game_seed: int

## [Dictionary] to hold the players unique ID and name.
var players: Dictionary[int, String] = {}

## The unique ID of the player corresponding to the current client.
var this_player_id: int


@rpc("any_peer", "reliable")
func register_player(player_id: int, player_name: String) -> void:
	print("(" + str(this_player_id) + ") Registering player: " + str(player_id))
	GameData.players[player_id] = player_name


@rpc("any_peer", "call_local", "reliable")
func set_game_seed(s: int) -> void:
	print("(" + str(this_player_id) + ") New game seed: " + str(s))
	seed(s) # for rand()
	GameData.game_seed = s # for own random function eg. deck shuffle
