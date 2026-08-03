class_name MultiplayerLobby
extends Control
## Lobby scene for players to host and connect to the game. From here the actual
## game scenes are also loaded for each player.
##

@export var game_scene: PackedScene

@onready var multiplayer_manager: MultiplayerManager = %MultiplayerManager
@onready var host_button: Button = %HostButton
@onready var join_button: Button = %JoinButton
@onready var start_button: Button = %StartButton
@onready var title_label: Label = %TitleLabel
@onready var name_entry: LineEdit = %NameEntry


func _ready() -> void:
	host_button.pressed.connect(_on_host_button_pressed)
	join_button.pressed.connect(_on_join_button_pressed)
	start_button.pressed.connect(_on_start_button_pressed)
	start_button.hide()


## Changes the scene to the game scene.
# TODO this could be in own scene and wrapped with scene transitions. I defs seen this in a youtube video
@rpc("any_peer", "call_local")
func change_scene() -> void:
	get_tree().change_scene_to_packed(game_scene)


func _on_host_button_pressed() -> void:
	multiplayer_manager.player_name = name_entry.text
	
	if multiplayer_manager.create_game() != OK:
		return
	
	host_button.hide()
	join_button.hide()
	name_entry.hide()
	start_button.show()
	title_label.text = "Start game when ready..." # TODO add how many players (connect to on peer connected signal)


func _on_join_button_pressed() -> void:
	multiplayer_manager.player_name = name_entry.text
	
	if multiplayer_manager.join_game() != OK:
		return
	
	host_button.hide()
	join_button.hide()
	name_entry.hide()
	title_label.text = "Waiting for host to start..."


func _on_start_button_pressed() -> void:
	multiplayer_manager.send_game_data_to_clients()
	change_scene.rpc()
