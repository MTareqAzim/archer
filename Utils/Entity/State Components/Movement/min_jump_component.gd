extends EntityStateComponent

export (String) var body_key
export (String) var input_handler_key
export (int) var min_jump_height := 50

var _body : KinematicBody2P5D
var _input : InputHandler


func handle_input(event: InputEvent) -> void:
	if event.is_action_released("jump"):
		_limit_z_velocity()


func update(delta: float) -> void:
	if not _input.is_action_pressed("jump"):
		_limit_z_velocity()


func assign_dependencies() -> void:
	_body = component_state.get_dependency(body_key)
	_input = component_state.get_dependency(input_handler_key)


func _limit_z_velocity() -> void:
	var min_jump_velocity = -sqrt(2 * _body.get_grav() * min_jump_height)
	if _body.get_velocity().z < min_jump_velocity:
		_body.set_z_velocity(min_jump_velocity)
