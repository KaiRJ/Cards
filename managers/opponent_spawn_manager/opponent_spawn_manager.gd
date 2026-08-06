class_name OpponentSpawnManager
extends Node
## 
##

## The game deck that all the opponents will be connected to.
@export var deck: Deck

## The opponents on the left of the screen.
@export var left_opponent_scenes: PackedScene

## The opponents on the top of the screen.
@export var top_opponent_scenes: PackedScene

## The opponents on the right of the screen.
@export var right_opponent_scenes: PackedScene


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
	var players: Array[int] = GameManager.players.keys()
	var n_players: int = len(players)
	var n_opponents: int = n_players - 1
	var opponent_scenes: Array[PackedScene] = get_opponent_scenes(n_opponents)
	
	var first_opponent_idx: int = players.find(multiplayer.get_unique_id()) + 1
	for i: int in range(n_opponents): # loop over all opponents
		# use % to loop back around the array
		var opponent_idx: int = (first_opponent_idx + i) % n_players
		var oppenent_id: int = players[opponent_idx]
		var opponent_scene: PackedScene = opponent_scenes.pop_front()
		setup_opponent(oppenent_id, opponent_scene)


## Set up and add the opponent to the scene.
func setup_opponent(id: int, opponent_scene: PackedScene) -> void:
	var opponent: Opponent = opponent_scene.instantiate()
	deck.deal.connect(opponent._on_dealt_card)
	add_child(opponent)
	opponent.set_id(id)
