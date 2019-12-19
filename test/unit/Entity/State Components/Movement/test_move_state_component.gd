extends "res://addons/gut/test.gd"

var input_move : MoveStateComponent
var doubled_body : KinematicBody2P5D
var doubled_input : InputHandler

func before_each():
	input_move = MoveStateComponent.new()
	doubled_body = double(KinematicBody2P5D).new()
	doubled_input = double(InputHandler).new()
	add_child(doubled_body)
	add_child(doubled_input)
	
	input_move._body = doubled_body
	input_move._input_handler = doubled_input
	add_child(input_move)

func after_each():
	for child in get_children():
		child.free()

func before_all():
	pass

func after_all():
	pass

func test_move():
	stub(doubled_input, "get_direction").to_return(Vector2(1, 0))
	input_move.update(0.1)
	assert_called(doubled_body, "set_velocity_2d")

func test_move_inputs():
	var max_speed = 300
	input_move.max_speed = max_speed
	
	stub(doubled_input, "get_direction").to_return(Vector2(0, 1))
	input_move.update(0.1)
	var velocity = Vector2(0, 1).normalized() * max_speed
	assert_called(doubled_body, "set_velocity_2d", [velocity])
	
	stub(doubled_input, "get_direction").to_return(Vector2(0, 0))
	input_move.update(0.1)
	velocity = Vector2()
	assert_called(doubled_body, "set_velocity_2d", [velocity])
	
	stub(doubled_input, "get_direction").to_return(Vector2(-1, -1))
	input_move.update(0.1)
	velocity = Vector2(-1, -1).normalized() * max_speed
	assert_called(doubled_body, "set_velocity_2d", [velocity])