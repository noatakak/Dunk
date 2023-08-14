extends RayCast3D

var sum

func _ready():
	sum = 1

func _process(_delta):
	pass
	sum += _delta
	if is_colliding() and sum > 1 and get_collider().has_meta("type"):
		$prompt.visible = true
		if Input.is_action_just_pressed("interact"):
			sum = 0
			var coll = get_collider()
			$prompt.visible = false
			if coll.has_meta("type"):
				if coll.get_meta("type") == "air":
					AudioManager.play_air_refill()
					coll.get_parent().get_parent().get_parent().get_parent().o2_level += 60
					if coll.get_parent().get_parent().get_parent().get_parent().o2_level > 100:
						coll.get_parent().get_parent().get_parent().get_parent().o2_level = 100
					coll.get_parent().get_parent().visible = false
				if coll.get_meta("type") == "power":
					AudioManager.play_battery_insert()
					coll.get_parent().get_parent().get_parent().get_parent().battery_level = 100
					coll.get_parent().get_parent().visible = false
				if coll.get_meta("type") == "part":
					AudioManager.play_crunch()
					coll.get_parent().get_parent().get_parent().get_parent().parts_level += 1
					coll.get_parent().get_parent().visible = false
					coll.get_parent().get_parent().get_parent().get_parent().get_node("dunk_container").get_node("dunk").state = "chase"
					coll.get_parent().get_parent().get_parent().get_parent().get_node("dunk_container").get_node("dunk").get_node("fish").get_node("detection_zone").get_node("shape").shape.radius += 5
				if coll.get_meta("type") == "sub" and coll.get_parent().get_parent().get_parent().get_parent().parts_level >= 5:
					coll.get_parent().get_parent().get_parent().get_parent().win_display()
				if coll.get_meta("type") == "sub" and coll.get_parent().get_parent().get_parent().get_parent().parts_level < 5:
					AudioManager.play_crunch()
	else:	
		$prompt.visible = false
