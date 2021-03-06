extends InputHandler
class_name PlayerInputHandler, "input.png"

onready var _action_buffer : ActionBuffer = get_node(action_buffer)

export (Array, NodePath) var state_machines
export (NodePath) var action_buffer

var _map : Array = []
var _state_machines : Array = []


func _ready():
	for node_path in state_machines:
		_state_machines.append(get_node(node_path))
	
	repopulate_map()


func _unhandled_input(event):
	_set_direction_events_as_handled(event)
	_map_and_distribute_event(event)


func add_child(node: Node, legible_unique_name: bool = false) -> void:
	.add_child(node, legible_unique_name)
	repopulate_map()


func remove_child(node: Node) -> void:
	.remove_child(node)
	repopulate_map()


func get_direction() -> Vector2:
	var input_direction = Vector2()
	input_direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input_direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	return input_direction


func is_action_pressed(action: String) -> bool:
	return Input.is_action_pressed(action)


func repopulate_map() -> void:
	_map = _get_populated_map()


func _get_populated_map() -> Array:
	var map : Array = []
	
	for child in get_children():
		if child is ActionMap:
			map.append(child)
	
	return map


func _set_direction_events_as_handled(event: InputEvent) -> void:
		if event.is_action("ui_right") \
		or event.is_action("ui_left") \
		or event.is_action("ui_up") \
		or event.is_action("ui_down"):
			get_tree().set_input_as_handled()


func _map_and_distribute_event(event: InputEvent) -> void:
	for action_map in _map:
		var mapped_event = action_map.map(event)
		if mapped_event:
			_register_event(mapped_event)
			for state_machine in _state_machines:
				state_machine.handle_input(mapped_event)
			get_tree().set_input_as_handled()


func _register_event(event: InputEventAction) -> void:
	if event.is_pressed():
		Input.action_press(event.get_action(), 1)
		_action_buffer.add_action(event.get_action() + "_pressed")
	else:
		Input.action_release(event.get_action())
		_action_buffer.add_action(event.get_action() + "_released")
