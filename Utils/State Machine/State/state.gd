extends Node
class_name State, "state.png"

signal finished(next_state_name)

export (String) var state_name := "state name"
export (bool) var push_down := false
export (bool) var overwrite := false


func get_class() -> String:
	return "State"


func is_class(type: String) -> bool:
	return type == "State" or .is_class(type)


func enter() -> void:
	return


func exit() -> void:
	return


func handle_input(event: InputEvent) -> void:
	return


func update(delta: float) -> void:
	return
