extends Node
## Autoload used to store persistant data during the game.
## 

## The seed used to sycronise games between players.
var game_seed: int

## [Dictionary] to hold the players unique ID and name.
var players: Dictionary[int, String] = {}


@rpc("any_peer", "reliable")
func set_player(player_id: int, player_name: String) -> void:
	GameManager.players[player_id] = player_name


@rpc("any_peer", "reliable")
func set_game_seed(s: int) -> void:
	GameManager.game_seed = s
