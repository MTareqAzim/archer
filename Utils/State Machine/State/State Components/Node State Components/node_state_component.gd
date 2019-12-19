extends StateComponent
class_name NodeStateComponent, "node_state_component.png"

var node : Node

export (String) var node_key


func get_class() -> String:
	return "NodeStateComponent"


func is_class(type: String) -> bool:
	return type == "NodeStateComponent" or .is_class(type)


func assign_dependencies() -> void:
	node = component_state.get_dependency(node_key)