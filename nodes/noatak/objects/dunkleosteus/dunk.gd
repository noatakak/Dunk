extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D

@export var SPEED: float = 0

@onready var start = false

# options: patrol, chase, flee, idle
@onready var state = "patrol"

@export var ai: bool = true

var player_loc
var patrol_points

@onready var attack = false

func _physics_process(delta):
	if ai:
		$"NavigationAgent3D".PROCESS_MODE_INHERIT
	else:
		$"NavigationAgent3D".PROCESS_MODE_DISABLED
	if start:
		check_if_reached()
		set_speed_and_anim()
		set_new_velo(delta)
	if state == "chase" and nav_agent.distance_to_target() < 7:
		$"fish/Dunkleosteus/AnimationPlayer".play("Bite0")
	
func check_if_reached():
	if nav_agent.distance_to_target() < 1 or nav_agent.target_position == Vector3(0, 0, 0):
		state = "patrol"
		$"fish".position.y = 15
		var new_patrol = patrol_points.duplicate()
		new_patrol.sort()
		new_patrol.erase(0)
		var new_target = new_patrol[randi() % new_patrol.size()]
		update_target_location(new_target)

func set_speed_and_anim():
	if state == "idle":
		if SPEED != 0:
			$fish/Dunkleosteus/AnimationPlayer.play("Idle0")
		SPEED = 0
	if state == "patrol":
		if SPEED != 3:
			$"fish/Dunkleosteus/AnimationPlayer".play("Swim0")
		SPEED = 3
	if state == "chase":
		if SPEED != 8:
			$"fish/audio_container/target".play()
			$"fish/Dunkleosteus/AnimationPlayer".play("Speed1")
		update_target_location(player_loc)
		SPEED = 8
	if state == "flee":
		if SPEED != 10:
			var max_distance = 1
			var new_target
			for point in patrol_points:
				var distance_from_dunk = global_position.distance_to(point)
				if distance_from_dunk > max_distance:
					max_distance = distance_from_dunk
					new_target = point
			update_target_location(new_target)
			$"fish/Dunkleosteus/AnimationPlayer".play("constraint")
			await $"fish/Dunkleosteus/AnimationPlayer".animation_finished
			$"fish/Dunkleosteus/AnimationPlayer".play("Speed1")
		SPEED = 10
	
func set_new_velo(delta):
	var next_location = nav_agent.get_next_path_position()
	var direction = global_position.direction_to(next_location)
	global_position += direction * delta * SPEED
	
	if state == "chase" and nav_agent.distance_to_target() < 30:
		next_location = nav_agent.target_position
		$"fish".position.y = (nav_agent.distance_to_target()/30) * 15 + 1
	
	var target_direction = (next_location - global_transform.origin).normalized()
	var current_direction = -global_transform.basis.z.normalized()
	var new_direction = current_direction.lerp(target_direction, SPEED * delta)
	look_at(global_transform.origin + new_direction)
	
#	if state == "chase" and nav_agent.distance_to_target() < 50:
#		$"fish".look_at(global_transform.origin + new_direction)

func get_navigation_points(player, patrols):
	player_loc = player
	patrol_points = patrols

func update_target_location(target_location):
	nav_agent.target_position = target_location

func _on_timer_timeout():
	start = true

func _on_detection_zone_body_entered(body):
	if state == "patrol" and body.name == "player":
		state = "chase"
	print(body)
