extends Area3D

var direction: Vector3 = Vector3.FORWARD
@export var speed: float = 30.0

func _physics_process(delta: float) -> void:
	position = position + direction * speed * delta
	

func _on_timer_timeout() -> void:
	queue_free()


func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("enemy_area"):
		#print(area)
		area.get_parent().current_health -= 25
		queue_free()
