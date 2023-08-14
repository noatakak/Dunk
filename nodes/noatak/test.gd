extends Node

@onready var player = $Player

func _physics_process(_delta):
	get_tree().call_group("dunk", "update_target_location", player.global_transform.origin)
