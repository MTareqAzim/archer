extends EntityStateComponent
class_name MoveStateComponent, "move_state_component.png"

export (String) var body_key
export (String) var input_handler_key
export (int) var max_speed := 0

var _body : KinematicBody2D
var _input_handler : InputHandler


func update(delta: float) -> void:
	var input_direction = _input_handler.get_direction()
	var velocity = input_direction.normalized() * max_speed
	
	_body.set_velocity_x(velocity.x)


func assign_dependencies() -> void:
	_body = component_state.get_dependency(body_key)
	_input_handler = component_state.get_dependency(input_handler_key)