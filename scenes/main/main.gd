extends Control

func _ready() -> void:
	$Deck.deal.connect($Player._on_dealt_card)
