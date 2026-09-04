class_name Card
extends PanelContainer
## This scene contains all the functionality of individual cards.
##

signal card_selected(card: Card)

enum Suit {
	HEARTS,
	DIAMONDS,
	SPADES,
	CLUBS,
	JOKER
}

enum Facing {
	UP,
	DOWN,
	HIDDEN}

## The front card texture.
@export var front: Texture2D

## The back card texture.
@export var back: Texture2D

## The suit of this card.
var suit: Suit:
	get: return suit

## The value of this card.
var value: int:
	get: return value

@onready var face: TextureRect = %Face
@onready var button: Button = %Button


func _ready() -> void:
	button.pressed.connect(_on_button_pressed)


## Sets the cards textures and it's value and suit based on this texture.
func initialise_card(front_texture: Texture2D, back_texture: Texture2D = back) -> void:
	# set the textures
	front = front_texture
	back = back_texture

	# get the card data
	suit = _get_card_suit()
	value = _get_card_value()


## Simple wrapper for setting up [Card]s using other [Card]s.
func copy_from_card(new_card: Card) -> void:
	initialise_card(new_card.front, new_card.back)


## Return true if two cards are the same.
func equals(card: Card) -> bool:
	if card == null:
		return false

	return (self.front == card.front) and (self.back == card.back)


## TODO
func facing(f: Facing) -> void:
	match f:
		Facing.UP:
			face.modulate.a = 1.0
			face.texture = front
		Facing.DOWN:
			face.modulate.a = 1.0
			face.texture = back
		Facing.HIDDEN:
			face.modulate.a = 0.0


func is_facing(f: Facing) -> bool:
	match f:
		Facing.UP:
			return face.texture == front
		Facing.DOWN:
			return face.texture == back
		Facing.HIDDEN:
			return face.modulate.a == 0.0
	return false


## Turns the card over to it's other side.
func flip() -> void:
	if face.texture == front:
		face.texture = back
	else:
		face.texture = front


func _on_button_pressed() -> void:
	card_selected.emit(self)


func _get_card_suit() -> Suit:
	const suits_map: Dictionary[String, Suit] = {
		"H" : Suit.HEARTS,
		"D" : Suit.DIAMONDS,
		"S" : Suit.SPADES,
		"C" : Suit.CLUBS,
		"J" : Suit.JOKER
		}

	var front_texture_filename: String  = front.resource_path.get_file().get_basename()
	var suit_id: String = front_texture_filename[0]
	return suits_map[suit_id]


## Return the value of this card.
func _get_card_value() -> int:
	var front_texture_filename: String  = front.resource_path.get_file().get_basename()
	var value_id: String = front_texture_filename[1]

	if (value_id == "T"): return 10
	if (value_id == "J"): return 10
	if (value_id == "Q"): return 10
	if (value_id == "K"): return 10

	return value_id.to_int()
