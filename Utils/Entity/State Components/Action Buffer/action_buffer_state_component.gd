tool
extends EntityStateComponent
class_name ActionBufferStateComponent, "action_buffer.png"

export (String) var action_buffer_key
export (bool) var enter_only := false
export (String) var action
export (int) var frames

var _action_buffer : ActionBuffer
var _activate : bool = true
var _state_components : Dictionary = {}
var _activated : bool


func _ready() -> void:
	_append_state_components(self)
	_set_activated(not _activate, true)


func _get_configuration_warning() -> String:
	return "Don't use this component. Use it's subclasses."


func enter() -> void:
	print("here")
	_check_and_activate(true)


func update(delta: float) -> void:
	if not enter_only:
		_check_and_activate()


func assign_dependencies() -> void:
	_action_buffer = component_state.get_dependency(action_buffer_key)


func _append_state_components(node : Node) -> void:
	for child in node.get_children():
		if child is StateComponent:
			_state_components[child] = child.active
		if child.get_child_count() > 0:
			_append_state_components(child)


func _check_and_activate(force: bool = false) -> void:
	if _action_buffer.action_within(action, frames):
		_set_activated(_activate, force)
	else:
		_set_activated(not _activate, force)


func _set_activated(activated: bool, force: bool = false) -> void:
	if not force:
		if _activated == activated:
			return
	
	_activated = activated
	_activate_children(_activated)


func _activate_children(active: bool) -> void:
	for component in _state_components:
		if active:
			component.set_active(_state_components[component])
		else:
			component.set_active(active)