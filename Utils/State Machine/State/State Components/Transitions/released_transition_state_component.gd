extends StateComponent
class_name ReleasedTransitionStateComponent, "released_transition_state_component.png"

export (String) var ACTION
export (String) var NEXT_STATE


func get_class() -> String:
	return "ReleasedTransitionStateComponent"


func handle_input(event: InputEvent) -> void:
	if event.is_action_released(ACTION):
		component_state.finished(NEXT_STATE)