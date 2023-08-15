extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D

@export var SPEED: float = 0

@onready var start = false

# options: patrol, chase, flee, idle
@onready var state = "patrol"

var player_loc
var patrol_points

@onready var attack = false

func _physics_process(delta):
	if start:
		check_if_reached()
		set_speed_and_anim()
		set_new_velo(delta)
	if state == "chase" and $"fish".global_position.distance_to(player_loc) < 7:
		$"fish/Dunkleosteus/AnimationPlayer".play("Bite0")
	
func check_if_reached():
	if nav_agent.distance_to_target() < 2 or nav_agent.target_position == Vector3(0, 0, 0):
		state = "patrol"
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
		if SPEED != 5:
			$"fish/Dunkleosteus/AnimationPlayer".play("Swim0")
		SPEED = 5
	if state == "chase":
		if SPEED != 9:
			$"fish/audio_container/target".play()
			$"fish/Dunkleosteus/AnimationPlayer".play("Speed1")
		update_target_location(player_loc)
		SPEED = 9
	if state == "flee":
		if SPEED != 8:
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
		SPEED = 8
	
func set_new_velo(delta):
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	nav_agent.set_velocity(new_velocity)
	
	var target_rotation = get_global_transform().looking_at(next_location, Vector3.UP).basis.get_euler()
	rotation.y = lerp(rotation.y, target_rotation.y, delta * SPEED/10)
	if state == "chase":
		target_rotation = get_global_transform().looking_at(player_loc, Vector3.UP).basis.get_euler()
	#rotation.x = lerp(rotation.x, target_rotation.x, delta * SPEED/10)
	if player_loc.distance_to(global_position) < 40:
		$"fish".position.y = ((nav_agent.distance_to_target() - 40)/40) * 20 -6

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


func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, .25)
	move_and_slide()
