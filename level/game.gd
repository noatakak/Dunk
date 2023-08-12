extends Node

@onready var flashlight = $"Player/player/Camera/SpotLight3D"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("toggle_flashlight"):
		flashlight.visible = !flashlight.visible
