extends RayCast3D

var current_object

func _process(delta):
	if is_colliding():
		var object = get_collider()
		if object == current_object:
			return
		current_object = object
	else:
		current_object = null
