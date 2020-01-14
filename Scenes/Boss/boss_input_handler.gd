extends InputHandler

export (NodePath) var look_direction
export (NodePath) var edge_detectors
export (NodePath) var player_detector

export (NodePath) var state_machine

onready var _edge_detectors : Area2D = get_node(edge_detectors)
onready var _edge_detectors_timer : Timer = $"Edge Detectors Timer"

onready var _player_detector : Area2D = get_node(player_detector)
onready var _player_detector_timer : Timer = $"Player Detector Timer"

onready var _look_direction : LookDirection = get_node(look_direction)

onready var _state_machine : StateMachine = get_node(state_machine)

var _player : KinematicBody2D = null

var _pressed_actions : Array = []
var _current_movement_state : String

var _check_edge_detectors : bool = true
var _can_growl : bool = true


func _physics_process(delta):
	pass


func get_direction() -> Vector2:
	var direction = Vector2()
	
	if _current_movement_state == "patrol":
		direction = _patrol()
	
	return direction


func is_action_pressed(action: String) -> bool:
	if action in _pressed_actions:
		return true
	
	return false


func _event_happened(event: InputEventAction) -> void:
	if event.pressed:
		if not is_action_pressed(event.action):
			_pressed_actions.append(event.action)
	else:
		if is_action_pressed(event.action):
			_pressed_actions.erase(event.action)
	
	_state_machine.handle_input(event)


func _patrol() -> Vector2:
	if _check_edge_detectors:
		if _look_direction.get_look_direction() == 1:
			_set_new_direction_if_overlapping(-1)
		elif _look_direction.get_look_direction() == -1:
			_set_new_direction_if_overlapping(1)
	
	return Vector2(_look_direction.get_look_direction(), 0)


func _set_new_direction_if_overlapping(new_direction: int) -> void:
	if _edge_detectors.get_overlapping_bodies():
		_look_direction.set_look_direction(new_direction)
		_reset_check_edge_detectors()


func _reset_check_edge_detectors() -> void:
	_check_edge_detectors = false
	_edge_detectors_timer.start()


func _growl() -> void:
	var growl = InputEventAction.new()
	growl.action = "growl"
	growl.pressed = true
	
	_event_happened(growl)


func _on_Movement_state_changed(current_state):
	_current_movement_state = current_state.state_name


func _on_Edge_Detectors_Timer_timeout():
	_check_edge_detectors = true


func _on_Player_Detector_body_entered(body):
	_player = body
	if _can_growl:
		_growl()


func _on_Player_Detector_body_exited(body):
	if body == _player:
		_player = null
		
		var growl = InputEventAction.new()
		growl.action = "growl"
		growl.pressed = false
		_event_happened(growl)


func _on_Player_Detector_Timer_timeout():
	_can_growl = true
