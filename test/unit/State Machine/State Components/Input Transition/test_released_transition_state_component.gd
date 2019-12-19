extends "res://addons/gut/test.gd"

var released : ReleasedTransitionStateComponent = null

func before_each():
	released = ReleasedTransitionStateComponent.new()

func after_each():
	for child in get_children():
		child.free()

func before_all():
	pass

func after_all():
	pass

func test_handle_input_called():
	var doubled_released : ReleasedTransitionStateComponent = double(ReleasedTransitionStateComponent).new()
	doubled_released.active = true
	
	var state = ComponentState.new()
	state.add_child(doubled_released)
	
	add_child(state)
	
	var test_input = InputEvent.new()
	state.handle_input(test_input)
	assert_called(doubled_released, "handle_input", [test_input])


func test_released_transition():
	var doubled_state = double(ComponentState).new()
	
	var test_input = InputEventAction.new()
	test_input.action = "test"
	test_input.pressed = false
	
	released.component_state = doubled_state
	released.ACTION = "test"
	released.NEXT_STATE = "next_state"
	
	add_child(released)
	
	released.handle_input(test_input)
	assert_called(doubled_state, "finished", ["next_state"])

func test_pressed():
	var doubled_state = double(ComponentState).new()
	
	var pressed_test_input = InputEventAction.new()
	pressed_test_input.action = "test"
	pressed_test_input.pressed = true
	
	released.component_state = doubled_state
	released.ACTION = "test"
	released.NEXT_STATE = "next_state"
	
	add_child(released)
	
	released.handle_input(pressed_test_input)
	assert_not_called(doubled_state, "finished", ["next_state"])