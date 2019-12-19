extends "res://addons/gut/test.gd"

var pressed : PressedTransitionStateComponent = null

func before_each():
	pressed = PressedTransitionStateComponent.new()

func after_each():
	for child in get_children():
		child.free()

func before_all():
	pass

func after_all():
	pass

func test_handle_input_called():
	var doubled_pressed : PressedTransitionStateComponent = double(PressedTransitionStateComponent).new()
	doubled_pressed.active = true
	
	var state = ComponentState.new()
	state.add_child(doubled_pressed)
	
	add_child(state)
	
	var test_input = InputEvent.new()
	state.handle_input(test_input)
	assert_called(doubled_pressed, "handle_input", [test_input])


func test_pressed_transition():
	var doubled_state = double(ComponentState).new()
	
	var test_input = InputEventAction.new()
	test_input.action = "test"
	test_input.pressed = true
	
	pressed.component_state = doubled_state
	pressed.ACTION = "test"
	pressed.NEXT_STATE = "next_state"
	
	add_child(pressed)
	
	pressed.handle_input(test_input)
	assert_called(doubled_state, "finished", ["next_state"])

func test_released():
	var doubled_state = double(ComponentState).new()
	
	var released_test_input = InputEventAction.new()
	released_test_input.action = "test"
	released_test_input.pressed = false
	
	pressed.component_state = doubled_state
	pressed.ACTION = "test"
	pressed.NEXT_STATE = "next_state"
	
	add_child(pressed)
	
	pressed.handle_input(released_test_input)
	assert_not_called(doubled_state, "finished", ["next_state"])