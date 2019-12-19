tool
extends NodeStateComponent
class_name CallFunctionStateComponent, "fun.png"

export (String) var FUNCTION_NAME
export (bool) var has_args := true
export (Array) var args


func _get_configuration_warning() -> String:
	return "Don't use this component. Use it's subclasses."


func call_function() -> void:
	if has_args:
		node.callv(FUNCTION_NAME, args)
	else:
		node.call(FUNCTION_NAME)