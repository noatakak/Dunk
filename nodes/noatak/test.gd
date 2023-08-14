extends Node

@onready var player = $Player/player

@onready var parts_level = 0

func _physics_process(_delta):
	var list = $"path_container".get_children().map(func(part): return part.global_transform.origin)
	get_tree().call_group("dunk", "get_navigation_points", player.global_transform.origin, list)
