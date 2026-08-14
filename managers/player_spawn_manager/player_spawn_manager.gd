class_name PlayerSpawnManager
extends Node
## TODO
##

## The game deck that all the players will be connected to.
@export var deck: Deck

## The player on the bottom of the screen.
@export var bottom_player_scene: PackedScene

## The player on the left of the screen.
@export var left_player_scene: PackedScene

## The player on the top of the screen.
@export var top_player_scene: PackedScene

## The player on the right of the screen.
@export var right_player_scene: PackedScene

## TODO
var players: Dictionary[int, String] = {}

## The unique ID of the player corresponding to the current client.
var this_player_id: int


## Get the order players will be spawned in the game.
func get_player_scenes(n: int) -> Array[PackedScene]:
	if n == 1:
		return [bottom_player_scene]
	elif n == 2:
		return [bottom_player_scene, top_player_scene]
	elif n == 3:
		return [bottom_player_scene, left_player_scene, top_player_scene]
	elif n == 4:
		return [bottom_player_scene, left_player_scene, top_player_scene, right_player_scene]
	else:
		push_error("Unsupport number of players: " + str(n))
		return []


## Spawn all the players in the correct order based on the player.
func spawn_players() -> void:
	# get the scenes used for spawning the players
	var n_players: int = len(players)
	var player_scenes: Array[PackedScene] = get_player_scenes(n_players)

	# get the index of the first player to be spawned
	var player_ids: Array[int] = players.keys()
	var first_player_idx: int = player_ids.find(this_player_id)

	# loop over all players
	for i: int in range(n_players):
		var player_scene: PackedScene = player_scenes.pop_front()
		var player: Player = player_scene.instantiate()
		add_child(player)

		# use % to loop back around the array
		var player_idx: int = (first_player_idx + i) % n_players
		var player_id: int = player_ids[player_idx]
		deck.deal.connect(player._on_dealt_card)
		player.player_id = player_id
		player.name_label.text = players[player_id]
