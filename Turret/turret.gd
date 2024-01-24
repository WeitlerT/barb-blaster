extends Node3D

@export var projectile: PackedScene
@export var turret_range: float = 10.0
#@onready var barrel: MeshInstance3D = $TurretBase/Barrel
var enemy_path: Path3D
var target: PathFollow3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cannon: Node3D = $TurretBase/TurretTop/Cannon
@onready var turret_base: MeshInstance3D = $TurretBase

func _physics_process(delta: float) -> void:
	target = find_best_target()
	#We add this check so when we run out of enemies to target we don't run into an error with the look_at method
	if target != null:
		turret_base.look_at(target.global_position, Vector3.UP, true)

func _on_timer_timeout() -> void:
	#We add this check so if no enemies are left the turrets don't keep firing
	if target != null:
		var shot = projectile.instantiate()
		add_child(shot)
		shot.global_position = cannon.global_position
		#We use global_transform.basis instead of just basis because if our main scene is rotated at all (Not just set to 0) then local basis has no idea and won't work as intended
		shot.direction = turret_base.global_transform.basis.z
		animation_player.play("fire")

func find_best_target() -> PathFollow3D:
	var best_target = null
	var best_progress = 0
	#Loop through all children of enemy_path (Our Path3D node)
	for enemy in enemy_path.get_children():
		#We don't want the Road CSGs so we make sure to only check for PathFollow3D nodes (the enemies)
		if enemy is PathFollow3D:
			if enemy.progress > best_progress:
				#Check it is in range of turret
				var distance = global_position.distance_to(enemy.global_position)
				if distance <= turret_range:
					#If the current enemy being focused has better progress than our current best progress we want to make that enemy the best target as well as update our best_progress var with that enemies progress
					best_target = enemy
					best_progress = enemy.progress
	#Return the best_target
	return best_target
