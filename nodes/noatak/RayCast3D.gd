extends RayCast3D

var sum

func _ready():
	sum = 2

func _process(_delta):
	pass
#	sum += _delta
#	if is_colliding() and not DialogBox.visible and sum > 2:
#		$prompt.visible = truesdawad
#		if Input.is_action_just_pressed("interact"):
#			sum = 0
#			var coll = get_collider()
#			$prompt.visible = false
#			if coll.has_meta("destination"):
#				$prompt.visible = false
#				if coll.get_meta("destination") != "res://levels/level7/level_7.tscn":
#					LevelTransition.change_level(true, false, true, coll.get_meta("destination"), "")
#				else:
#					LevelTransition.change_level(true, true, true, coll.get_meta("destination"), "scientist")
#			elif coll.has_meta("dialog_id"):
#				$prompt.visible = false
#				DialogBox.open_dialog(coll.get_meta("dialog_id"))
#	else:
#		$prompt.visible = false
