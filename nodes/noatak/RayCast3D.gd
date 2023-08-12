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
			if coll.has_meta("destination"):
				$prompt.visible = false
			elif coll.has_meta("dialog_id"):
				$prompt.visible = false
	else:
		$prompt.visible = false
