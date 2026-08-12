class_name OpponentSpawnManager
extends Node
## TODO
##

## The game deck that all the opponents will be connected to.
@export var deck: Deck

## The opponents on the left of the screen.
@export var left_opponent_scenes: PackedScene

## The opponents on the top of the screen.
@export var top_opponent_scenes: PackedScene

## The opponents on the right of the screen.
@export var right_opponent_scenes: PackedScene


## TODO
var players: Dictionary[int, String] = {}


## Get the order opponents will be spawned in the game.
func get_opponent_scenes(n: int) -> Array[PackedScene]:
	if n == 1:
		return [top_opponent_scenes]
	elif n == 2:
		return [left_opponent_scenes, top_opponent_scenes]
	elif n == 3:
		return [left_opponent_scenes, top_opponent_scenes, right_opponent_scenes]
	else:
		push_error("Unsupport number of opponents: " + str(n))
		return []


## Spawn all the opponents in the correct order based on the player.
func spawn_opponents() -> void:
	# get the scenes used for spawning the opponents
	var n_players: int = len(players)
	var n_opponents: int = n_players - 1
	var opponent_scenes: Array[PackedScene] = get_opponent_scenes(n_opponents)

	# get the index of the first opponent to be spawned
	var player_ids: Array[int] = players.keys()
	var first_opponent_idx: int = player_ids.find(multiplayer.get_unique_id()) + 1

	# loop over all opponents
	for i: int in range(n_opponents):
		var opponent_scene: PackedScene = opponent_scenes.pop_front()
		var opponent: Opponent = opponent_scene.instantiate()
		add_child(opponent)

		# use % to loop back around the array
		var opponent_idx: int = (first_opponent_idx + i) % n_players
		var oppenent_id: int = player_ids[opponent_idx]
		deck.deal.connect(opponent._on_dealt_card)
		opponent.opponent_id = oppenent_id
		opponent.name_label.text = players[oppenent_id]
