extends StateComponent
class_name AnimationFinishedTransitionStateComponent

export (String) var animation
export (String) var NEXT_STATE

func on_animation_finished(finished_animation: String) -> void:
	if finished_animation == animation:
		component_state.finished(NEXT_STATE)
