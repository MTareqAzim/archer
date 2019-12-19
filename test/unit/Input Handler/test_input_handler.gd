extends "res://addons/gut/test.gd"

var input_handler : InputHandler

func before_each():
	input_handler = InputHandler.new()

func after_each():
	for child in get_children():
		child.free()

func before_all():
	pass

func after_all():
	pass

func test_get_direction():
	add_child(input_handler)
	
	assert_eq(input_handler.get_direction(), Vector2())