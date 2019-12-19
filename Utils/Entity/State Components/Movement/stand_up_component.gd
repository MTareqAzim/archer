extends EntityStateComponent

onready var _timer : Timer = $Timer

export (float) var duration := 0.2
export (String) var next_state


func enter() -> void:
	_set_values()
	_timer.set_one_shot(true)
	_timer.start()


func exit() -> void:
	_timer.stop()


func _set_values() -> void:
	_timer.set_wait_time(duration)


func _on_Timer_timeout():
	component_state.finished(next_state)
