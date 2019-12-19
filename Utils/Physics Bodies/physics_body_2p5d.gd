extends Area2D
class_name PhysicsBody2P5D


func get_class() -> String:
	return "PhysicsBody2P5D"


func is_class(type: String) -> bool:
	return type == "PhysicsBody2P5D" or .is_class(type)


func get_z_pos() -> int:
	return 0


func get_height() -> int:
	return 0


func get_base_shapes(z_pos: int) -> Array:
	return []


func get_base_transform() -> Transform2D:
	return Transform2D()


func get_top_z_pos(points: Array) -> int:
	return 0