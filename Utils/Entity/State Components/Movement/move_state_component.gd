extends EntityStateComponent
class_name MoveStateComponent, "move_state_component.png"

export (String) var body_key
export (String) var input_handler_key
export (String) var max_speed_key := "max_speed"

var _body : KinematicBody2D
var _input_handler : InputHandler
var _max_speed : int


func update(delta: float) -> void:
	var input_direction = _input_handler.get_direction()
	var target_velocity = input_direction.normalized() * _max_speed
	var current_velocity = _body.get_velocity()
	var next_velocity_x = lerp(current_velocity.x, target_velocity.x, 0.3)
	
	_body.set_velocity_x(next_velocity_x)


func assign_dependencies() -> void:
	_body = component_state.get_dependency(body_key)
	_input_handler = component_state.get_dependency(input_handler_key)


func assign_variables() -> void:
	_max_speed = component_state.get_variable(max_speed_key)