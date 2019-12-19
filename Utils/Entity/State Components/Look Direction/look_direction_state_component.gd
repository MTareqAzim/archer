extends EntityStateComponent
class_name LookDirectionStateComponent, "look_direction.png"

export (String) var look_direction_key
export (String) var input_handler_key

var _look_direction : LookDirection
var _input_handler : InputHandler

func update(delta: float) -> void:
	var look_direction = _input_handler.get_direction()
	_update_look_direction(look_direction)


func assign_dependencies() -> void:
	_look_direction = component_state.get_dependency(look_direction_key)
	_input_handler = component_state.get_dependency(input_handler_key)


func _update_look_direction(direction: Vector2) -> void:
	if _look_direction.get_look_direction() == direction.x:
		return
	
	_look_direction.set_look_direction(direction.x)