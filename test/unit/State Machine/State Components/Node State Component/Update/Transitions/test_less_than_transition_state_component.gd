extends "res://addons/gut/test.gd"

var less_than_component : LessThanTransitionStateComponent
var doubled_state : ComponentState
var doubled_body : KinematicBody2P5D

func before_each():
	less_than_component = LessThanTransitionStateComponent.new()
	doubled_state = double(ComponentState).new()
	doubled_body = double(KinematicBody2P5D).new()
	
	doubled_state.add_child(less_than_component)
	add_child(doubled_body)
	add_child(doubled_state)
	
	less_than_component.node = doubled_body
	less_than_component.component_state = doubled_state

func after_each():
	for child in get_children():
		child.free()

func before_all():
	pass

func after_all():
	pass

func test_less_than_transition():
	stub(doubled_body, "get_z_velocity").to_return(2)
	
	less_than_component.FUNCTION_NAME = "get_z_velocity"
	less_than_component.has_args = false
	less_than_component.args = []
	less_than_component.less_than = [7]
	less_than_component.NEXT_STATE = "next_state"
	
	less_than_component.update(0.1)
	assert_called(doubled_state, "finished", ["next_state"])

func test_greater_than_no_transition():
	stub(doubled_body, "get_z_velocity").to_return(10)
	
	less_than_component.FUNCTION_NAME = "get_z_velocity"
	less_than_component.has_args = false
	less_than_component.args = []
	less_than_component.less_than = [8]
	less_than_component.NEXT_STATE = "next_state"
	
	less_than_component.update(0.1)
	assert_not_called(doubled_state, "finished", ["next_state"])

func test_equals_no_transition():
	stub(doubled_body, "get_z_velocity").to_return(5)
	
	less_than_component.FUNCTION_NAME = "get_z_velocity"
	less_than_component.has_args = false
	less_than_component.args = []
	less_than_component.less_than = [5]
	less_than_component.NEXT_STATE = "next_state"
	
	less_than_component.update(0.1)
	assert_not_called(doubled_state, "finished", ["next_state"])


func test_function_with_args():
	stub(doubled_body, "get_top_z_pos").to_return(5).when_passed([3, 2, 1])
	
	less_than_component.FUNCTION_NAME = "get_top_z_pos"
	less_than_component.has_args = true
	less_than_component.args = [[3, 2, 1]]
	less_than_component.less_than = [7]
	less_than_component.NEXT_STATE = "next_state"
	
	less_than_component.update(0.1)
	assert_called(doubled_state, "finished", ["next_state"])