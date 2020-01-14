extends Node
class_name LookDirection, "look_direction.png"

signal direction_changed(new_direction)

enum Direction {RIGHT = 1, LEFT = -1, UNDEFINED = 0}

var _look_direction : int = Direction.RIGHT setget set_look_direction, get_look_direction


func set_look_direction(new_look_direction: int) -> void:
	if new_look_direction == Direction.UNDEFINED:
		return
	
	_look_direction = new_look_direction
	emit_signal("direction_changed", new_look_direction)


func get_look_direction() -> int:
	return _look_direction