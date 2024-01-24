extends MarginContainer

@export var starting_gold: int = 150
@onready var label: Label = $Label

var gold: int:
	set(gold_in):
		gold = gold_in
		#Could also use gold = max(gold_in, 0)
		if gold < 0:
			gold = 0
		label.text = "Gold: " + str(gold)

func _ready() -> void:
	gold = starting_gold
