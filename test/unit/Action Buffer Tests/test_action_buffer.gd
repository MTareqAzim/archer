extends "res://addons/gut/test.gd"

var action_buffer : ActionBuffer

func before_each():
	action_buffer = ActionBuffer.new()
	add_child(action_buffer)

func after_each():
	action_buffer.queue_free()

func before_all():
	pass

func after_all():
	pass

func test_add_action():
	action_buffer.add_action("test")
	assert_true(action_buffer.action_within("test"), "Does not contain the test action.")

func test_action_within_5_frames():
	action_buffer.add_action("test")
	gut.simulate(action_buffer, 4, 0.1)
	assert_true(action_buffer.action_within("test", 5), "Does not contain the test action.")
	
	gut.simulate(action_buffer, 1, 0.1)
	assert_false(action_buffer.action_within("test", 5), "Contains the test action within the last 5 frames when it shouldn't.")

func test_action_handled():
	action_buffer.add_action("test")
	assert_true(action_buffer.action_within("test"), "Action is missing.")
	
	action_buffer.action_handled("test")
	assert_false(action_buffer.action_within("test"), "Action was not handled successfully.")

func test_action_removed_past_threshold():
	action_buffer.add_action("test")
	assert_true(action_buffer.action_within("test"), "Action is missing.")
	gut.simulate(action_buffer, action_buffer.FRAME_BUFFER_LIMIT, 0.1)
	assert_false(action_buffer.action_within("test"), "Action still present when it should have been deleted after x frames.")

func test_action_overwrites_previous_action():
	action_buffer.add_action("test")
	assert_true(action_buffer.action_within("test"), "Action is missing.")
	gut.simulate(action_buffer, 5, 0.1)
	assert_false(action_buffer.action_within("test", 5), "Action is within 5 frames when it shouldn't be.")
	action_buffer.add_action("test")
	assert_true(action_buffer.action_within("test", 1), "Action is not within 1 frame when it should have been overwritten.")
