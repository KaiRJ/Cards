class_name Card
extends TextureRect
## This scene contains all the functionality of individual cards.

## The front card texture
@export var front: Texture2D

## The back card texture
@export var back: Texture2D

enum Suit {
	HEARTS,
	DIAMONDS,
	SPADES,
	CLUBS,
	JOKER
}

var suit: Suit:
	get: return suit

var value: int:
	get: return value


## TODO
func setup_card(front_texture: Texture2D, back_texture: Texture2D) -> void:
	# set the textures
	front = front_texture
	back = back_texture

	## get the card data
	suit = _get_card_suit()
	value = _get_card_value()


## Return the suit of this card.
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
