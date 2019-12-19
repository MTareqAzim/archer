extends "res://addons/gut/test.gd"

var equals_component : EqualsTransitionStateComponent
var doubled_state : ComponentState
var doubled_body : KinematicBody2P5D

func before_each():
	equals_component = EqualsTransitionStateComponent.new()
	doubled_state = double(ComponentState).new()
	doubled_body = double(KinematicBody2P5D).new()
	
	doubled_state.add_child(equals_component)
	add_child(doubled_body)
	add_child(doubled_state)
	
	equals_component.node = doubled_body
	equals_component.component_state = doubled_state

func after_each():
	for child in get_children():
		child.free()

func before_all():
	pass

func after_all():
	pass


func test_equals_transition():
	var velocity = Vector3(0, 1, 2)
	stub(doubled_body, "get_velocity").to_return(velocity)
	
	equals_component.FUNCTION_NAME = "get_velocity"
	equals_component.has_args = false
	equals_component.args = []
	equals_component.equals = [Vector3(0, 1, 2)]
	equals_component.NEXT_STATE = "next_state"
	
	equals_component.update(0.1)
	assert_called(doubled_state, "finished", ["next_state"])

func test_not_equals_no_transition():
	var velocity = Vector3(2, 1, 0)
	stub(doubled_body, "get_velocity").to_return(velocity)
	
	equals_component.FUNCTION_NAME = "get_velocity"
	equals_component.has_args = false
	equals_component.args = []
	equals_component.equals = [Vector3(0, 0, 0)]
	equals_component.NEXT_STATE = "next_state"
	
	equals_component.update(0.1)
	assert_not_called(doubled_state, "finished", ["next_state"])


func test_function_with_args():
	stub(doubled_body, "get_top_z_pos").to_return(5).when_passed([0, 0, 0])
	
	equals_component.FUNCTION_NAME = "get_top_z_pos"
	equals_component.has_args = true
	equals_component.args = [[0, 0, 0]]
	equals_component.equals = [5]
	equals_component.NEXT_STATE = "next_state"
	
	equals_component.update(0.1)
	assert_called(doubled_state, "finished", ["next_state"])