extends NodeStateComponent
class_name LessThanTransitionStateComponent, "less_than_transition.png"

export (String) var FUNCTION_NAME
export (bool) var has_args := false
export (Array) var args
export (Array) var less_than
export (String) var NEXT_STATE

func update(delta: float) -> void:
	var variable
	
	if has_args:
		variable = node.callv(FUNCTION_NAME, args)
	else:
		variable = node.call(FUNCTION_NAME)
	
	if variable < less_than[0]:
		component_state.finished(NEXT_STATE)