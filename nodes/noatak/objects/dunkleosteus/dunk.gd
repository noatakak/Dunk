extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D

@export var SPEED: float = 3

@onready var start = false

func _physics_process(delta):
	set_new_velo(delta)
	move_and_slide()
	
func set_new_velo(delta):
	if start:
		var next_location = nav_agent.get_next_path_position()
		var direction = global_position.direction_to(next_location)
		global_position += direction * delta * SPEED
#		var current_location = global_transform.origin
#		var next_location = nav_agent.get_next_path_position()
#		var new_velocity = (next_location - current_location).normalized() * SPEED
#		velocity = new_velocity

func update_target_location(target_location):
	nav_agent.target_position = target_location

func _on_timer_timeout():
	start = true
