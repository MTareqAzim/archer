extends EntityStateComponent

export (int) var max_jump_height := 100
export (float) var jump_duration := 0.5

func enter():
	_set_values()


func _set_values():
	var new_gravity = int(round((2 * max_jump_height) / pow(jump_duration, 2)))
	var z_velocity = int(-new_gravity * jump_duration)
	
	$"Enter Gravity".args = [new_gravity]
	$"Enter Z Velocity".args = [z_velocity]