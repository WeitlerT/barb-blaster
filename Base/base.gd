extends Node3D

@onready var label_3d: Label3D = $Label3D
@export var max_health: int = 5
var current_health: int:
	set(health_in):
		current_health = health_in
		#print("Health was changed")
		label_3d.text = str(current_health) + "/" + str(max_health)
		var red: Color = Color.RED
		var white: Color = Color.WHITE
		label_3d.modulate = red.lerp(white, float(current_health) / float(max_health))
		if current_health < 1:
			get_tree().reload_current_scene()

func _ready() -> void:
	current_health = max_health

func take_damage() -> void:
	#print("Damage dealt to base")
	current_health = current_health - 1
