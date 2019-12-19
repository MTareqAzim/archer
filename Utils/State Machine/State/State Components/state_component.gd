extends Node
class_name StateComponent, "state_component.png"

export (bool) var active := true setget set_active

var component_state = null


func get_class() -> String:
	return "StateComponent"


func is_class(type: String) -> bool:
	return type == "StateComponent" or .is_class(type)


func set_active(new_active: bool) -> void:
	active = new_active