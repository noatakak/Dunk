extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func play_air_refill():
	$"air-refill-player".play()

func play_alarm():
	$"alarm-player".play()

func stop_alarm():
	$"alarm-player".stop()

func play_ambient():
	$"ambient-player".play()

func stop_ambient():
	$"ambient-player".stop()

func play_battery_insert():
	$"battery-insert-player".play()

func play_beep():
	$"beep-player".play()

func play_click():
	$"click-player".play()

func play_crash():
	$"crash-player".play()

func play_crunch():
	$"crunch-player".play()

func play_death():
	$"death-player".play()

func play_error():
	$"error-player".play()

func play_footstep():
	$"footstep-player".play()

func play_light_switch():
	$"light-switch-player".play()
	
func play_metal_sheet():
	$metal_sheet_player.play()

func play_sonar():
	$"sonar-player".play()

func play_splash():
	$"splash-player".play()
