extends NodeStateComponent
class_name GreaterThanTransitionStateComponent, "greater_than_transition.png"

export (String) var FUNCTION_NAME
export (bool) var has_args := false
export (Array) var args
export (Array) var greater_than
export (String) var NEXT_STATE

func update(delta: float) -> void:
	var variable
	if has_args:
		variable = node.callv(FUNCTION_NAME, args)
	else:
		variable = node.call(FUNCTION_NAME)
	
	if variable > greater_than[0]:
		component_state.finished(NEXT_STATE)