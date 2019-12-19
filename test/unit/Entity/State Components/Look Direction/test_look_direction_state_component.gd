extends "res://addons/gut/test.gd"

var look_direction_state_component : LookDirectionStateComponent
var doubled_look_direction : LookDirection
var doubled_input_handler : InputHandler

func before_each():
	look_direction_state_component = LookDirectionStateComponent.new()
	doubled_look_direction = double(LookDirection).new()
	doubled_input_handler = double(InputHandler).new()

func after_each():
	for child in get_children():
		child.free()

func before_all():
	pass

func after_all():
	pass

func _test_look_direction_state_component():
	var test_direction = Vector2(1, -1)
	stub(doubled_input_handler, "get_direction").to_return(test_direction)
	
	add_child(doubled_input_handler)
	add_child(doubled_look_direction)
	
	look_direction_state_component._look_direction = doubled_look_direction
	look_direction_state_component._input_handler = doubled_input_handler
	
	add_child(look_direction_state_component)
	
	look_direction_state_component.update(0.1)
	assert_called(doubled_look_direction, "set_direction", [test_direction])

func test_same_direction():
	var test_direction = Vector2(1, 0)
	stub(doubled_input_handler, "get_direction").to_return(test_direction)
	
	add_child(doubled_input_handler)
	add_child(doubled_look_direction)
	
	look_direction_state_component._look_direction = doubled_look_direction
	look_direction_state_component._input_handler = doubled_input_handler
	
	add_child(look_direction_state_component)
	
	look_direction_state_component.update(0.1)
	assert_not_called(doubled_look_direction, "set_direction")