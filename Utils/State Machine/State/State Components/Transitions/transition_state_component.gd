extends StateComponent
class_name TransitionStateComponent

export (String) var NEXT_STATE

func update(delta: float) -> void:
	component_state.finished(NEXT_STATE)
