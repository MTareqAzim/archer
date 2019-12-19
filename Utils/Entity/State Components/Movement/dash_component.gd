extends EntityStateComponent

onready var _timer : Timer = $Timer

export (String) var look_direction_key
export (int) var dash_distance := 300
export (float) var dash_duration := 0.5
export (String) var next_state

var _look_direction : LookDirection


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


func _set_values() -> void:
	var speed : float = dash_distance / dash_duration
	var direction : Vector2 = _look_direction.get_look_direction()
	
	$"Enter Velocity 2D".args = [direction * speed]
	$Timer.set_wait_time(dash_duration)


func _on_Timer_timeout():
	component_state.finished(next_state)
