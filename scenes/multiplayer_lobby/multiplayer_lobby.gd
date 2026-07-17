class_name MultiplayerLobby
extends Control
## Lobby scene for players to host and connect to the game. From here the actual
## game scenes are also loaded for each player.
##

@export var game_scene: PackedScene

@onready var multiplayer_manager: MultiplayerManager = $MultiplayerManager
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


## Changes the scene to the corrrect game scene.
# TODO this could be in own scene and wrapped with scene transitions. I defs seen this in a youtube video
@rpc("any_peer", "call_local")
func change_scene() -> void:
	get_tree().change_scene_to_packed(game_scene)


func _on_host_button_pressed() -> void:
	var error: Error = multiplayer_manager.create_game()
	if (error != OK):
		push_error("Cannot host: " + str(error))
		return
		
	GameManager.set_player(multiplayer.get_unique_id(), name_entry.text)
	host_button.hide()
	join_button.hide()
	name_entry.hide()
	start_button.show()
	title_label.text = "Start game when ready..." # TODO add how many players (connect to on peer connected signal)


func _on_join_button_pressed() -> void:
	var error: Error = multiplayer_manager.join_game()
	if (error != OK):
		push_error("Cannot join: " + str(error))
		return
	
	GameManager.set_player(multiplayer.get_unique_id(), name_entry.text)
	host_button.hide()
	join_button.hide()
	name_entry.hide()
	title_label.text = "Waiting for host to start..."


func _on_start_button_pressed() -> void:
	change_scene.rpc()
