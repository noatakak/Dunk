extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D

@export var SPEED: float = 3.0

func _physics_process(_delta):
	await get_tree().process_frame
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	velocity = new_velocity
	move_and_slide()

func update_target_location(target_location):
	nav_agent.target_position = target_location
