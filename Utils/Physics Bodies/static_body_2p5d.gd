extends PhysicsBody2P5D
class_name StaticBody2P5D


func get_class() -> String:
	return "StaticBody2P5D"


func is_class(type: String) -> bool:
	return type == "StaticBody2P5D" or .is_class(type)