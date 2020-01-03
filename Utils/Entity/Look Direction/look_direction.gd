extends Node
class_name LookDirection, "look_direction.png"

signal direction_changed(new_direction)

enum Aim {HIGH, MID, LOW}
enum Direction {RIGHT = 1, LEFT = -1, UNDEFINED = 0}

export (NodePath) var bow
export (float) var mid_angle := 15.0

onready var _bow = get_node(bow)

var _look_direction : int = Direction.RIGHT setget set_look_direction, get_look_direction


func set_look_direction(new_look_direction: int) -> void:
	if new_look_direction == Direction.UNDEFINED:
		return
	
	_look_direction = new_look_direction
	emit_signal("direction_changed", new_look_direction)


func get_look_direction() -> int:
	return _look_direction


func get_aim() -> int:
	var aim_direction = _get_aim_direction()
	
	set_look_direction(sign(aim_direction.x))
	
	var aim_angle = rad2deg(aim_direction.angle())
	
	var aim = _get_aim(aim_angle)
	return aim


func _get_aim_direction() -> Vector2:
	var mouse_position = _bow.get_global_mouse_position()
	var bow_position = _bow.get_global_position()
	var aim_direction = (mouse_position - bow_position).normalized()
	
	return aim_direction


func _get_aim(aim_angle: float) -> int:
	if aim_angle < -mid_angle and aim_angle > mid_angle - 180.0:
		return Aim.HIGH
	elif aim_angle > mid_angle and aim_angle < 180.0 - mid_angle:
		return Aim.LOW
	
	return Aim.MID