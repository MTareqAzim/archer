extends "res://addons/gut/test.gd"

var player_input : PlayerInputHandler

func before_each():
	player_input = PlayerInputHandler.new()

func after_each():
	for child in get_children():
		child.free()
	
	for action in InputMap.get_actions():
		Input.action_release(action)

func before_all():
	pass

func after_all():
	pass

func test_move_input():
	add_child(player_input)
	
	Input.action_press("ui_up")
	
	assert_eq(player_input.get_direction(), Vector2(0, -1))
	
	Input.action_release("ui_up")
	
	assert_eq(player_input.get_direction(), Vector2(0, 0))
	
	Input.action_press("ui_down")
	Input.action_press("ui_left")
	
	assert_eq(player_input.get_direction(), Vector2(-1, 1))

func test_input():
	var doubled_state_machine = double(StateMachine).new()
	add_child(doubled_state_machine)
	
	var doubled_action_buffer = double(ActionBuffer).new()
	add_child(doubled_action_buffer)
	
	var doubled_action_map = double(ActionMap).new()
	player_input.add_child(doubled_action_map)
	player_input.state_machine = doubled_state_machine.get_path()
	player_input.action_buffer = doubled_action_buffer.get_path()
	add_child(player_input)
	
	var test_input = InputEventAction.new()
	test_input.action = "test"
	test_input.pressed = true
	
	player_input._unhandled_input(test_input)
	assert_not_called(doubled_state_machine, "handle_input")
	
	var test_action = InputEventAction.new()
	test_action.action = "test"
	test_action.pressed = true
	stub(doubled_action_map, "map").to_return(test_action)
	
	player_input._unhandled_input(test_input)
	assert_called(doubled_state_machine, "handle_input", [test_action])