extends "res://addons/gut/test.gd"

var greater_than_component : GreaterThanTransitionStateComponent
var doubled_state : ComponentState
var doubled_body : KinematicBody2P5D

func before_each():
	greater_than_component = GreaterThanTransitionStateComponent.new()
	doubled_state = double(ComponentState).new()
	doubled_body = double(KinematicBody2P5D).new()
	
	doubled_state.add_child(greater_than_component)
	add_child(doubled_body)
	add_child(doubled_state)
	
	greater_than_component.node = doubled_body
	greater_than_component.component_state = doubled_state

func after_each():
	for child in get_children():
		child.free()

func before_all():
	pass

func after_all():
	pass

func test_greater_than_transition():
	stub(doubled_body, "get_z_velocity").to_return(7)
	
	greater_than_component.FUNCTION_NAME = "get_z_velocity"
	greater_than_component.has_args = false
	greater_than_component.args = []
	greater_than_component.greater_than = [5]
	greater_than_component.NEXT_STATE = "next_state"
	
	greater_than_component.update(0.1)
	assert_called(doubled_state, "finished", ["next_state"])

func test_less_than_no_transition():
	stub(doubled_body, "get_z_velocity").to_return(0)
	
	greater_than_component.FUNCTION_NAME = "get_z_velocity"
	greater_than_component.has_args = false
	greater_than_component.args = []
	greater_than_component.greater_than = [2]
	greater_than_component.NEXT_STATE = "next_state"
	
	greater_than_component.update(0.1)
	assert_not_called(doubled_state, "finished", ["next_state"])

func test_equals_no_transition():
	stub(doubled_body, "get_z_velocity").to_return(3)
	
	greater_than_component.FUNCTION_NAME = "get_z_velocity"
	greater_than_component.has_args = false
	greater_than_component.args = []
	greater_than_component.greater_than = [3]
	greater_than_component.NEXT_STATE = "next_state"
	
	greater_than_component.update(0.1)
	assert_not_called(doubled_state, "finished", ["next_state"])


func test_function_with_args():
	stub(doubled_body, "get_top_z_pos").to_return(5).when_passed([1, 2, 3])
	
	greater_than_component.FUNCTION_NAME = "get_top_z_pos"
	greater_than_component.has_args = true
	greater_than_component.args = [[1, 2, 3]]
	greater_than_component.greater_than = [2]
	greater_than_component.NEXT_STATE = "next_state"
	
	greater_than_component.update(0.1)
	assert_called(doubled_state, "finished", ["next_state"])