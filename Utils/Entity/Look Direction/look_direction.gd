extends Node
class_name LookDirection, "look_direction.png"

signal direction_changed(new_direction)

const RIGHT : int = 1
const LEFT : int = -1
const UNDEFINED : int = 0

var _look_direction : int = RIGHT setget set_look_direction, get_look_direction


func set_look_direction(new_look_direction: int) -> void:
	if new_look_direction == UNDEFINED:
		return
	
	_look_direction = new_look_direction
	emit_signal("direction_changed", new_look_direction)


func get_look_direction() -> int:
	return _look_direction