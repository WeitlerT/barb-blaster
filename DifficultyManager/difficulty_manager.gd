extends Node

signal stop_spawning_enemies

@export var game_length := 30.0 ##In seconds
@export var spawn_time_curve: Curve
@onready var timer: Timer = $Timer
@export var enemy_health_curve: Curve

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start(game_length)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(get_spawn_time())
	pass

func game_progress_ratio() -> float:
	return 1.0 - (timer.time_left / game_length)

func get_spawn_time() -> float:
	return spawn_time_curve.sample(game_progress_ratio())

func get_enemy_health() -> float:
	return enemy_health_curve.sample(game_progress_ratio())


func _on_timer_timeout() -> void:
	stop_spawning_enemies.emit()
