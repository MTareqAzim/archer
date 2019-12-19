extends "res://addons/gut/test.gd"

var action_map : ActionMap

func before_each():
	action_map = ActionMap.new()

func after_each():
	for child in get_children():
		child.free()

func before_all():
	pass

func after_all():
	pass

func test_map_action():
	action_map.action = "test"
	action_map.mapped_action = "jump"
	
	var test_event = InputEventAction.new()
	test_event.action = "false"
	test_event.pressed = false
	
	assert_null(action_map.map(test_event), "Does not return null when mismatched event.")
	
	test_event.action = "test"
	var mapped_event = action_map.map(test_event)
	
	assert_true(mapped_event.is_action("jump"), "Action not mapped to proper action.")
	assert_eq(mapped_event.is_action_pressed("jump"), test_event.pressed, "Does not retain information.")
	
	test_event.pressed = true
	mapped_event = action_map.map(test_event)
	
	assert_eq(mapped_event.is_action_pressed("jump"), test_event.pressed, "Does not retain information.")