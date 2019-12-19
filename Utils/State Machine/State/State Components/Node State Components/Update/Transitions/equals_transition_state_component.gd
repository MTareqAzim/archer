extends NodeStateComponent
class_name EqualsTransitionStateComponent, "equals_transition.png"

export (String) var FUNCTION_NAME
export (bool) var has_args
export (Array) var args
export (Array) var equals
export (String) var NEXT_STATE


func update(delta: float) -> void:
	var variable
	if has_args:
		variable = node.callv(FUNCTION_NAME, args)
	else:
		variable = node.call(FUNCTION_NAME)
	
	if variable == equals[0]:
		component_state.finished(NEXT_STATE)