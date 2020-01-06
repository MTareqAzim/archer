extends NodeStateComponent
class_name FunctionActivateComponentStateComponent, "fun.png"

export (bool) var _activate := true

export (String) var FUNCTION_NAME
export (bool) var has_args := true
export (Array, String) var args := []
export (Array) var equals := []

var _args = [] setget set_args
var _state_components : Dictionary = {}


func _ready() -> void:
	_append_state_components(self)


func set_args(new_args: Array) -> void:
	_args = new_args


func assign_variables() -> void:
	_args.clear()
	for key in args:
		_args.append(component_state.get_variable(key))


func enter() -> void:
	_check_and_activate()


func update(delta: float) -> void:
	_check_and_activate()


func _append_state_components(node : Node) -> void:
	for child in node.get_children():
		if child is StateComponent:
			_state_components[child] = child.active
		if child.get_child_count() > 0:
			_append_state_components(child)


func _check_and_activate() -> void:
	if _call_function():
		_activate_state_components(_activate)
	else:
		_activate_state_components(not _activate)


func _call_function() -> bool:
	var value
	if has_args:
		value = node.callv(FUNCTION_NAME, _args)
	else:
		value = node.call(FUNCTION_NAME)

	return equals.has(value)


func _activate_state_components(activate : bool) -> void:
	for child in _state_components:
		if activate:
			child.set_active(_state_components[child])
		else:
			child.set_active(activate)