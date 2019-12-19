extends Position2D

const RIGHT = 1
const LEFT = -1

func _on_Look_Direction_direction_changed(new_direction):
	if new_direction == RIGHT:
		rotation_degrees = 0
	elif new_direction == LEFT:
		rotation_degrees = 180
