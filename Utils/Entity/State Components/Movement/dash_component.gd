extends EntityStateComponent

onready var _timer : Timer = $Timer

export (String) var look_direction_key
export (String) var dash_distance_key := "dash_distance"
export (String) var dash_duration_key := "dash_duration"
export (String) var next_state

var _look_direction : LookDirection
var _dash_distance : int
var _dash_duration : float


func enter() -> void:
	_set_values()
	_timer.set_one_shot(true)
	_timer.start()


func update(delta: float) -> void:
	if _timer.is_stopped():
		component_state.finished(next_state)


func exit() -> void:
	_timer.stop()


func assign_dependencies() -> void:
	_look_direction = component_state.get_dependency(look_direction_key)


func assign_variables() -> void:
	_dash_distance = component_state.get_variable(dash_distance_key)
	_dash_duration = component_state.get_variable(dash_duration_key)


func _set_values() -> void:
	var speed : float = _dash_distance / _dash_duration
	var direction : int = _look_direction.get_look_direction()
	
	$"Enter Velocity".set_args([direction * speed])
	$Timer.set_wait_time(_dash_duration)


func _on_Timer_timeout():
	component_state.finished(next_state)
