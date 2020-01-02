extends EntityStateComponent

export (String) var max_jump_height_key := "max_jump_height"
export (String) var jump_duration_key := "jump_duration"

var _max_jump_height := 100
var _jump_duration := 0.5

func enter():
	_set_values()


func assign_variables() -> void:
	_max_jump_height = component_state.get_variable(max_jump_height_key)
	_jump_duration = component_state.get_variable(jump_duration_key)


func _set_values():
	var new_gravity = int(round((2 * _max_jump_height) / pow(_jump_duration, 2)))
	var y_velocity = int(-new_gravity * _jump_duration)
	
	$"Enter Gravity".set_args([new_gravity])
	$"Enter Y Velocity".set_args([y_velocity])