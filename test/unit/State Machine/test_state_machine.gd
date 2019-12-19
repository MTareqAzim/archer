extends "res://addons/gut/test.gd"

var state_machine : StateMachine

func before_each():
	state_machine = StateMachine.new()

func after_each():
	for child in get_children():
		child.queue_free()

func before_all():
	pass

func after_all():
	pass

func test_populate_state_machine():
	var state_a = State.new()
	state_a.state_name = "state_a"
	var state_b = State.new()
	state_b.state_name = "state_b"
	var state_c = State.new()
	state_c.state_name = "state_c"
	
	state_b.add_child(state_c)
	
	state_machine.add_child(state_a)
	state_machine.add_child(state_b)
	
	add_child(state_machine)
	var states = state_machine._states_map
	assert_has(states, "state_a", "Child not added.")
	assert_has(states, "state_b", "Child not added.")
	assert_has(states, "state_c", "Descendent not added.")
	assert_eq(state_machine.current_state, state_a, "Start state not first child state.")

func test_state_transition():
	var state_a = State.new()
	state_a.state_name = "state_a"
	var state_b = State.new()
	state_b.state_name = "state_b"
	var state_c = State.new()
	state_c.state_name = "state_c"
	
	state_b.add_child(state_c)
	
	state_machine.add_child(state_a)
	state_machine.add_child(state_b)
	
	add_child(state_machine)
	state_a.emit_signal("finished", "state_b")
	assert_eq(state_machine.current_state, state_b, "State did not transition properly.")
	state_b.emit_signal("finished", "state_c")
	assert_eq(state_machine.current_state, state_c, "State did not transition properly.")
	state_c.emit_signal("finished", "state_a")
	assert_eq(state_machine.current_state, state_a, "State did not transition properly.")