extends PathFollow3D

@export var speed: float = 2.5
@export var max_health: int = 50
@export var gold_reward: int = 15
@onready var bank = get_tree().get_first_node_in_group("bank")

var current_health: int:
	set(health_in):
		if health_in < current_health:
			animation_player.play("TakeDamage")
		current_health = health_in
		if current_health < 1:
			queue_free()
			bank.gold += gold_reward
			
@onready var base = get_tree().get_first_node_in_group("base")
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	current_health = max_health
	#Engine.time_scale = 2 we use this to make entire game run 2x faster

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress += delta * speed
	if progress_ratio == 1:
		base.take_damage()
		set_process(false)
		queue_free()
