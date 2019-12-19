extends Node
class_name ActionBuffer, "action_buffer.png"

signal buffer_changed(buffer_stack)

export (int) var FRAME_BUFFER_LIMIT := 60

var action_buffer : Dictionary = {}

func _physics_process(delta: float) -> void:
	for key in action_buffer:
		action_buffer[key] += 1
	
	action_buffer = _erase_old_inputs(action_buffer)
	emit_signal("buffer_changed", action_buffer)


func get_class() -> String:
	return "ActionBuffer"


func is_class(type: String) -> bool:
	return type == "ActionBuffer" or .is_class(type)


func add_action(key: String) -> void:
	action_buffer[key] = 0


func action_within(key: String, last_frames: int = FRAME_BUFFER_LIMIT) -> bool:
	if action_buffer.has(key):
		if action_buffer[key] < last_frames:
			return true
	
	return false


func action_handled(key: String) -> void:
	action_buffer.erase(key)


func _erase_old_inputs(buffer: Dictionary) -> Dictionary:
	var new_buffer := {}
	
	for key in buffer:
		if buffer[key] < FRAME_BUFFER_LIMIT:
			new_buffer[key] = buffer[key]
	
	return new_buffer