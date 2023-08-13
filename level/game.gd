extends Node

@export var battery_speed: int = 10
@export var air_speed: float = .5

@onready var flashlight = $"Player/player/Camera/SpotLight3D"
@onready var air_label = $"viewport/oxygen"
@onready var parts_label = $"viewport/parts"
@onready var battery_sprite = $"viewport/battery"
@onready var death_screen = $"Death Screen"

@onready var battery_level
@onready var o2_level
@onready var parts_level
@onready var alive

var playing_power_anim

func _ready():
	battery_level = 0
	o2_level = 25
	parts_level = 0
	alive = true
	
func _process(_delta):
	update_battery(_delta)
	update_air(_delta)
	check_for_flashlight_toggle()

		
func check_for_flashlight_toggle():
	if Input.is_action_just_pressed("toggle_flashlight"):
		if battery_level > 0:
			$"audio_manager/light_switch".play()
			flashlight.visible = !flashlight.visible
		elif battery_level <= 0:
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
		if alive:
			alive = false
			o2_death()
	air_label.text = "AIR:\n" + str(int(o2_level))

func o2_death():
	get_tree().paused = true
	death_screen.visible = true
	$'Player/player'.release_mouse()

func _on_button_pressed():
	get_tree().paused = false
	death_screen.visible = false
	get_tree().change_scene_to_file("res://main/main_menu.tscn")
