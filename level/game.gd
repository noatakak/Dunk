extends Node

@export var battery_speed: int = 10
@export var air_speed: float = .5

@onready var player = $Player/player

@onready var flashlight = $"Player/player/Camera/SpotLight3D"
@onready var air_label = $"viewport/oxygen"
@onready var parts_label = $"viewport/parts"
@onready var battery_sprite = $"viewport/battery"
@onready var death_screen = $"Death Screen"

# objectives
@onready var parts = $"part_container".get_children()

@onready var battery_level
@onready var o2_level
@onready var parts_level
@onready var alive

var playing_power_anim
# beep rhythms
# 2: 100+ (default)
@onready var timer_slowest_time: float = 2
@onready var timer_fastest_time: float = .1
var timer_time
var timer_container
var timer
var animation_speed

func _ready():
	CursorManager.visible = false
	battery_level = 0
	o2_level = 25
	parts_level = 0
	alive = true
	
	timer = Timer.new()
	timer.one_shot = true
	timer.autostart = true
	set_timer_time()
	timer.wait_time = timer_time
	
	timer_container = Node.new()
	timer_container.add_child(timer)
	add_child(timer_container)
	
func _process(_delta):
	update_battery(_delta)
	update_air(_delta)
	check_for_flashlight_toggle()
	parts_label.text = str(parts_level) + "/5"
	
	set_timer_time()
	if timer.is_stopped():
		AudioManager.play_beep()
		$"viewport/proximityBeep".set_speed_scale(animation_speed)
		$"viewport/proximityBeep".play()
		timer.start(timer_time)
	
	if flashlight.visible and $"Player/player/Camera/SpotLight3D/light-ray".is_colliding() and $"Player/player/Camera/SpotLight3D/light-ray".get_collider().name == "fish":
		$"dunk_container/dunk".state = "flee"
		
func _physics_process(_delta):
	var list = $"path_container".get_children().map(func(part): return part.global_transform.origin) + $"part_container".get_children().map(func(part): return part.global_transform.origin)
	get_tree().call_group("dunk", "get_navigation_points", player.global_transform.origin, list)
	if $"dunk_container/dunk".global_position.distance_to(player.global_position) < 2:
		death()
	

# find the closest part
# beep
func set_timer_time():
	var player_location = $"Player/player".global_position
	parts = $"part_container".get_children()
	
	var min_distance = 100
	for part in parts:
		var distance_from_player = player_location.distance_to(part.global_position)
		if distance_from_player < min_distance:
			min_distance = distance_from_player
		
	if min_distance >= 100:
		timer_time = timer_slowest_time
	else:
		timer_time = max(timer_slowest_time * (min_distance / 100), timer_fastest_time)
		
	if timer_time > 0:
		animation_speed = 1/timer_time
	else:
		print("timer time is 0")
		animation_speed = .5

		
func check_for_flashlight_toggle():
	if Input.is_action_just_pressed("toggle_flashlight"):
		if battery_level > 0:
			AudioManager.play_light_switch()
			flashlight.visible = !flashlight.visible
		elif battery_level <= 0:
			AudioManager.play_error()
			playing_power_anim = true
			battery_sprite.play("no_power")
			await battery_sprite.animation_finished
			battery_sprite.play("default")
			playing_power_anim = false
	
func update_battery(delta):
	if flashlight.visible:
		battery_level -= delta * battery_speed
		if !playing_power_anim:
			battery_sprite.play("default")
	if battery_level <= 0:
		battery_level = 0
		flashlight.visible = false
	elif battery_level <= 25 and battery_level > 0:
		battery_sprite.play("low_power")
	elif battery_level <= 50 and battery_level > 25:
		battery_sprite.play("medium_power")
	elif battery_level <= 75 and battery_level > 50:
		battery_sprite.play("high_power")
	elif battery_level <= 100 and battery_level > 75:
		battery_sprite.play("full_power")
	
func update_air(delta):
	o2_level -= delta * air_speed
	if o2_level < 0:
		o2_level = 0
		$fade.visible = true
		$"fade/animation".play("fade")
		await $"fade/animation".animation_finished
		if alive:
			alive = false
			death()
	if o2_level > 0:
		$"fade/animation".stop()
		$"fade".visible = false
	air_label.text = "AIR:\n" + str(int(o2_level))
	
func win_display():
	CursorManager.visible = true
	get_tree().paused = true
	$"Win Screen".visible = true
	$'Player/player'.release_mouse()
	AudioManager.play_sonar()

func death():
	CursorManager.visible = true
	get_tree().paused = true
	death_screen.visible = true
	AudioManager.play_death()
	$'Player/player'.release_mouse()

func _on_button_pressed():
	AudioManager.play_click()
	get_tree().paused = false
	death_screen.visible = false
	AudioManager.stop_ambient()
	get_tree().change_scene_to_file("res://main/main_menu.tscn")
	
func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause") and !death_screen.visible and !$PauseMenu.visible:
		get_tree().paused = true
		$'Player/player'.release_mouse()
		$PauseMenu.visible = true
		CursorManager.visible = true

func _on_resume_button_pressed():
	CursorManager.visible = false
	AudioManager.play_click()
	get_tree().paused = false
	$'Player/player'.capture_mouse()
	$PauseMenu.visible = false

func _on_menu_button_pressed():
	AudioManager.play_click()
	get_tree().paused = false
	death_screen.visible = false
	AudioManager.stop_ambient()
	get_tree().change_scene_to_file("res://main/main_menu.tscn")


func _on_back_button_pressed():
	AudioManager.play_click()
	$PauseMenu/ControlsMarginContainer.visible = false
	$PauseMenu/PauseMarginContainer.visible = true

func _on_controls_button_pressed():
	AudioManager.play_click()
	$PauseMenu/PauseMarginContainer.visible = false
	$PauseMenu/ControlsMarginContainer.visible = true
