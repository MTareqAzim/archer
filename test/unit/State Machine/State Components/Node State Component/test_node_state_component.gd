extends "res://addons/gut/test.gd"

var node_state_component : NodeStateComponent

func before_each():
	node_state_component = NodeStateComponent.new()

func after_each():
	for child in get_children():
		child.free()

func before_all():
	pass

func after_all():
	pass

func test_get_node():
	var node : Node = Node.new()
	add_child(node)
	
	var doubled_component_state = double(ComponentState).new()
	stub(doubled_component_state, "get_dependency").to_return(node).when_passed("node")
	
	node_state_component.node_key = "node"
	node_state_component.component_state = doubled_component_state
	doubled_component_state.add_child(node_state_component)
	
	add_child(doubled_component_state)
	
	node_state_component.assign_dependencies()
	assert_eq(node_state_component.node, node, "Incorrect node.")
	