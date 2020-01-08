tool
extends NodeStateComponent
class_name CallFunctionVariableStateComponent, "funv.png"

export (String) var FUNCTION_NAME
export (bool) var has_args := true
export (Array, String) var variables := []

var _args = [] setget set_args

func _get_configuration_warning() -> String:
	return "Don't use this component. Use it's subclasses."


func set_args(new_args: Array) -> void:
	_args = new_args


func call_function() -> void:
	if has_args:
		node.callv(FUNCTION_NAME, _args)
	else:
		node.call(FUNCTION_NAME)


func assign_variables() -> void:
	_args.clear()
	for key in variables:
		_args.append(component_state.get_variable(key))