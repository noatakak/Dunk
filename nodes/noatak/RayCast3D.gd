extends RayCast3D

var sum

func _ready():
	sum = 2

func _process(_delta):
	pass
	sum += _delta
	if is_colliding() and sum > 2:
		$prompt.visible = true
		if Input.is_action_just_pressed("interact"):
			sum = 0
			var coll = get_collider()
			$prompt.visible = false
			if coll.has_meta("type"):
				if coll.get_meta("type") == "air":
					coll.get_parent().get_parent().get_parent().get_node("audio_manager/air_refill").play()
					coll.get_parent().get_parent().get_parent().o2_level += 50
					coll.get_parent().get_parent().visible = false
				if coll.get_meta("type") == "power":
					coll.get_parent().get_parent().get_parent().battery_level = 100
					coll.get_parent().get_parent().visible = false
				if coll.get_meta("type") == "part":
					coll.get_parent().get_parent().get_parent().parts_level += 1
					coll.get_parent().get_parent().visible = false
				if coll.get_meta("type") == "sub" and coll.get_parent().get_parent().get_parent().parts_level >= 5:
					#win screen
					pass
	else:
		$prompt.visible = false
