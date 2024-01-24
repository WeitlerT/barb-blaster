extends Camera3D

#Export this variable so we can then assign our actual gridmap to this. This gives us access to our actual gridmap. This is important to know as this is core to access other nodes from within a scene.
@export var gridmap: GridMap
@export var turret_manager: Node3D
@export var turret_cost:int = 100

@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var bank = get_tree().get_first_node_in_group("bank")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_position: Vector2 = get_viewport().get_mouse_position()
	#Multiplying by 100 to make sure we hit the actual level (gridmap). Realistically 100 is more than enough we only need like 20 here
	ray_cast_3d.target_position = project_local_ray_normal(mouse_position) * 100.0
	#Forcing updates collision right away
	ray_cast_3d.force_raycast_update()
	#printt just prints multiple things seperated by tabs
	#printt (ray_cast_3d.get_collider(),ray_cast_3d.get_collision_point())
	if ray_cast_3d.is_colliding():
		#Check we have enough gold
		if bank.gold >= turret_cost:
			Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
			var collider = ray_cast_3d.get_collider()
			#Check if collider (where we are hovering) is a gridmap
			if collider is GridMap:
				var collision_point = ray_cast_3d.get_collision_point()
				#This allows us to actually get each cord for every tile hovered
				var cell = gridmap.local_to_map(collision_point)
				#print (cell)
				#Check for left click (added this through input map)
				if Input.is_action_pressed("click"):
					#We do this check with get_cell_item because without it we run into a bug where we can place tiles on the edges of tiles (tries to place below it as its a 3D space). With this check we make sure you can only place on top of the tiles (tile 0s/empty tiles)
					if gridmap.get_cell_item(cell) == 0:
						gridmap.set_cell_item(cell, 1)
						var tile_position = gridmap.map_to_local(cell)
						turret_manager.build_turret(tile_position)
						bank.gold -= turret_cost
		#We also want the cursor to change if you are still hovering the same tile you just purchased turret on so we add an else for this if statement as well
		else:
			Input.set_default_cursor_shape(Input.CURSOR_ARROW)				
	else:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
