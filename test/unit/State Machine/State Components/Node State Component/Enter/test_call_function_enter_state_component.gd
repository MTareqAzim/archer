extends "res://addons/gut/test.gd"

var func_component : CallFunctionEnterStateComponent
var doubled_body : KinematicBody2P5D

func before_each():
	func_component = CallFunctionEnterStateComponent.new()
	doubled_body = double(KinematicBody2P5D).new()
	
	add_child(func_component)
	add_child(doubled_body)
	
	func_component.node = doubled_body

func after_each():
	for child in get_children():
		child.free()

func before_all():
	pass

func after_all():
	pass


func test_call_function_no_args_on_enter():
	func_component.FUNCTION_NAME = "get_grav"
	func_component.has_args = false
	func_component.args = []
	
	func_component.enter()
	assert_called(doubled_body, "get_grav")


func test_call_function_with_args_on_enter():
	func_component.FUNCTION_NAME = "get_top_z_pos"
	func_component.has_args = true
	func_component.args = [[3, 2, 1 , 0]]
	
	func_component.enter()
	assert_called(doubled_body, "get_top_z_pos", [[3, 2, 1, 0]])