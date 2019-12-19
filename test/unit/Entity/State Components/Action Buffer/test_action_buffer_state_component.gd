extends "res://addons/gut/test.gd"

var buffer_component : ActionBufferStateComponent
var doubled_action_buffer : ActionBuffer

var component_active : StateComponent
var nested_component_active : StateComponent
var component_inactive : StateComponent
var nested_component_inactive : StateComponent

func before_each():
	buffer_component = ActionBufferStateComponent.new()
	doubled_action_buffer = double(ActionBuffer).new()
	
	buffer_component._action_buffer = doubled_action_buffer
	add_child(doubled_action_buffer)
	
	component_active = StateComponent.new()
	nested_component_active = StateComponent.new()
	component_inactive = StateComponent.new()
	nested_component_inactive = StateComponent.new()
	
	component_active.set_active(true)
	nested_component_active.set_active(true)
	component_inactive.set_active(false)
	nested_component_inactive.set_active(false)
	
	component_active.add_child(nested_component_inactive)
	component_inactive.add_child(nested_component_active)
	
	buffer_component.add_child(component_active)
	buffer_component.add_child(component_inactive)

func after_each():
	for child in get_children():
		child.free()

func before_all():
	pass

func after_all():
	pass

func test_dependency_assigned():
	var action_buffer_state_component = ActionBufferStateComponent.new()
	var doubled_component_state = double(ComponentState).new()
	
	stub(doubled_component_state, "get_dependency").to_return(doubled_action_buffer).when_passed("buffer")
	
	action_buffer_state_component.component_state = doubled_component_state
	action_buffer_state_component.action_buffer_key = "buffer"
	action_buffer_state_component.assign_dependencies()
	
	assert_eq(action_buffer_state_component._action_buffer, doubled_action_buffer)

func test_append_state_components():
	var component_a = StateComponent.new()
	var component_b = StateComponent.new()
	var component_c = StateComponent.new()
	
	component_a.add_child(component_b)
	add_child(component_c)
	buffer_component.add_child(component_a)
	add_child(buffer_component)
	
	var components = buffer_component._state_components
	assert_has(components, component_a, "Missing direct child component.")
	assert_has(components, component_b, "Missing child of direct child component.")
	assert_does_not_have(components, component_c, "Has non-descendent component.")

func test_activate_true_deactivates_children_on_ready():
	buffer_component._activate = true
	
	_initially_active_tests()
	
	add_child(buffer_component)
	
	_deactivated_tests()

func test_activate_false_keeps_children_active_state_on_ready():
	buffer_component._activate = false
	
	_initially_active_tests()
	
	add_child(buffer_component)
	
	_activated_tests()

func test_activate_true_reactivates_children():
	buffer_component._activate = true
	add_child(buffer_component)
	
	_initially_inactive_tests()
	
	stub(doubled_action_buffer, "action_within").to_return(true)
	buffer_component.enter()
	
	_activated_tests()

func test_activate_false_deactivates_children():
	buffer_component._activate = false
	add_child(buffer_component)
	
	_initially_active_tests()
	
	stub(doubled_action_buffer, "action_within").to_return(true)
	buffer_component.enter()
	
	_deactivated_tests()

func test_activate_true_buffer_false():
	buffer_component._activate = true
	add_child(buffer_component)
	
	_initially_inactive_tests()
	
	stub(doubled_action_buffer, "action_within").to_return(false)
	buffer_component.enter()
	
	_deactivated_tests()

func test_activate_false_buffer_false():
	buffer_component._activate = false
	add_child(buffer_component)
	
	_initially_active_tests()
	
	stub(doubled_action_buffer, "action_within").to_return(false)
	buffer_component.enter()
	
	_activated_tests()

func test_activate_true_update():
	buffer_component._activate = true
	buffer_component.enter_only = false
	add_child(buffer_component)
	
	stub(doubled_action_buffer, "action_within").to_return(true)
	buffer_component.enter()
	#Components reactived based on previous test.
	stub(doubled_action_buffer, "action_within").to_return(false)
	buffer_component.update(0.1)
	
	_deactivated_tests()

func test_activate_false_update():
	buffer_component._activate = false
	buffer_component.enter_only = false
	add_child(buffer_component)
	
	stub(doubled_action_buffer, "action_within").to_return(true)
	buffer_component.enter()
	#Components deactivated based on previous test.
	stub(doubled_action_buffer, "action_within").to_return(false)
	buffer_component.update(0.1)
	
	_activated_tests()

func test_enter_only():
	buffer_component._activate = true
	buffer_component.enter_only = true
	add_child(buffer_component)
	
	stub(doubled_action_buffer, "action_within").to_return(true)
	buffer_component.enter()
	#Components reactived based on previous test.
	stub(doubled_action_buffer, "action_within").to_return(false)
	buffer_component.update(0.1)
	
	_activated_tests()


#Helper functions
func _initially_active_tests():
	assert_true(component_active.active, "Component not initially active.")
	assert_false(component_inactive.active, "Component not initially inactive.")
	assert_true(nested_component_active.active, "Component not initially active.")
	assert_false(nested_component_inactive.active, "Component not initially inactive.")


func _initially_inactive_tests():
	assert_false(component_active.active, "Component not initially inactive.")
	assert_false(component_inactive.active, "Component not initially inactive.")
	assert_false(nested_component_active.active, "Component not initially inactive.")
	assert_false(nested_component_inactive.active, "Component not initally inactive.")


func _activated_tests():
	assert_true(component_active.active, "Component not properly kept active state.")
	assert_false(component_inactive.active, "Component not properly kept inactive state.")
	assert_true(nested_component_active.active, "Component not properly kept active state.")
	assert_false(nested_component_inactive.active, "Component not properly kept inactive state.")


func _deactivated_tests():
	assert_false(component_active.active, "Component not properly deactivated.")
	assert_false(component_inactive.active, "Component does not stay inactive.")
	assert_false(nested_component_active.active, "Component not properly deactivated.")
	assert_false(nested_component_inactive.active, "Component does not stay inactive.")