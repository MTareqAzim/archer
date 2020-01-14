extends Node

enum Aim {HIGH, MID, LOW}

export (NodePath) var bow
export (float) var mid_angle := 15.0

onready var _bow = get_node(bow)


func get_aim() -> int:
	var aim_vector = _get_aim_vector()
	
	var aim_angle = rad2deg(aim_vector.angle())
	
	var aim = _get_aim(aim_angle)
	return aim


func get_aim_direction() -> int:
	var aim_vector = _get_aim_vector()
	
	return int(sign(aim_vector.x))


func _get_aim_vector() -> Vector2:
	var mouse_position = _bow.get_global_mouse_position()
	var bow_position = _bow.get_global_position()
	var aim_vector = (mouse_position - bow_position).normalized()
	
	return aim_vector


func _get_aim(aim_angle: float) -> int:
	if aim_angle < -mid_angle and aim_angle > mid_angle - 180.0:
		return Aim.HIGH
	elif aim_angle > mid_angle and aim_angle < 180.0 - mid_angle:
		return Aim.LOW
	
	return Aim.MID