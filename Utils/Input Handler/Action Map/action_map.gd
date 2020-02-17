extends Node
class_name ActionMap, "action_map.png"

export (String) var action
export (String) var mapped_action

func map(event : InputEvent) -> InputEvent:
	if not event.is_action(action):
		return null

	if event.is_echo():
		return null
	
	var mapped_event = InputEventAction.new()
	mapped_event.action = mapped_action
	mapped_event.pressed = event.is_action_pressed(action)
	
	return mapped_event
