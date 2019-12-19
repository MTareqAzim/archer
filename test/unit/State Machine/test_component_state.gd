extends "res://addons/gut/test.gd"

var state_machine : StateMachine = null
var component_state : ComponentState = null

func before_each():
	state_machine = StateMachine.new()
	component_state = ComponentState.new()

func after_each():
	for child in get_children():
		child.free()

func before_all():
	pass

func after_all():
	pass

func test_component_state():
	var doubled_component_state = double(ComponentState).new()
	state_machine.add_child(doubled_component_state)
	add_child(state_machine)
	
	gut.simulate(state_machine, 1, 0.1)
	assert_called(doubled_component_state, "update", [0.1])
	
	var test_input = InputEventAction.new()
	state_machine._unhandled_input(test_input)
	assert_called(doubled_component_state, "handle_input", [test_input])

func test_append_state_components():
	var state_component_a = StateComponent.new()
	var state_component_b = StateComponent.new()
	var state_component_c = StateComponent.new()
	var state_component_d = StateComponent.new()
	
	state_component_b.add_child(state_component_c)
	
	component_state.add_child(state_component_a)
	component_state.add_child(state_component_b)
	
	add_child(component_state)
	var components = component_state._components
	assert_has(components, state_component_a, "Component not added.")
	assert_has(components, state_component_b, "Component not added.")
	assert_has(components, state_component_c, "Descendent component not added.")
	assert_does_not_have(components, state_component_d, "Component added when shouldn't have.")

func test_nested_component_states():
	var diff_component_state = ComponentState.new()
	var state_component_a = StateComponent.new()
	var state_component_b = StateComponent.new()
	
	diff_component_state.add_child(state_component_b)
	component_state.add_child(state_component_a)
	component_state.add_child(diff_component_state)
	
	add_child(component_state)
	var components = component_state._components
	var diff_components = diff_component_state._components
	
	assert_has(components, state_component_a, "Component not added.")
	assert_does_not_have(components, state_component_b, "Component added to wrong component state.")
	assert_has(diff_components, state_component_b, "Component not added.")
	assert_does_not_have(diff_components, state_component_a, "Component added to wrong component state.")

func test_finished():
	var component_state_a = ComponentState.new()
	component_state_a.state_name = "state_a"
	var component_state_b = ComponentState.new()
	component_state_b.state_name = "state_b"
	
	state_machine.add_child(component_state_a)
	state_machine.add_child(component_state_b)
	
	add_child(state_machine)
	
	assert_eq(state_machine.current_state, component_state_a, "State machine not properly initialized.")
	component_state_a.finished("state_b")
	assert_eq(state_machine.current_state, component_state_b, "State not properly transitioned.")
	component_state_b.finished("state_a")
	assert_eq(state_machine.current_state, component_state_a, "State not properly transitioned.")