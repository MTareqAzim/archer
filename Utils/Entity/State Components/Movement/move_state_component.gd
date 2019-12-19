extends EntityStateComponent
class_name MoveStateComponent, "move_state_component.png"

export (String) var body_key
export (String) var input_handler_key
export (int) var max_speed := 0

var _body : KinematicBody2P5D
var _input_handler : InputHandler


func update(delta: float) -> void:
	var input_direction = _input_handler.get_direction()
	_move_2d(input_direction, max_speed)


func assign_dependencies() -> void:
	_body = component_state.get_dependency(body_key)
	_input_handler = component_state.get_dependency(input_handler_key)


func _move_2d(direction: Vector2, speed: int) -> void:
	var velocity_2d = direction.normalized() * speed
	_body.set_velocity_2d(velocity_2d)
