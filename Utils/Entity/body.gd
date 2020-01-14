extends KinematicBody2D

export var max_speed := Vector2(2000.0, 2000.0)
export var gravity : int = 1200 setget set_gravity, get_gravity

var velocity : Vector2 = Vector2.ZERO setget set_velocity, get_velocity


func _physics_process(delta: float):
	velocity = _apply_gravity(velocity, delta)
	velocity = _clamp_velocity(velocity)
	velocity = move_and_slide(velocity, Vector2.UP)


func set_gravity(new_gravity: int) -> void:
	gravity = new_gravity


func get_gravity() -> int:
	return gravity


func set_velocity(new_velocity: Vector2) -> void:
	velocity = new_velocity


func set_velocity_x(new_velocity_x: float) -> void:
	velocity.x = new_velocity_x


func set_velocity_y(new_velocity_y: float) -> void:
	velocity.y = new_velocity_y


func get_velocity() -> Vector2:
	return velocity


func get_velocity_x() -> int:
	return int(round(velocity.x))


func get_velocity_y() -> int:
	return int(round(velocity.y))


func is_grounded() -> bool:
	return test_move(self.transform, Vector2(0,1))


func _apply_gravity(velocity: Vector2, delta: float) -> Vector2:
		if not is_grounded():
			velocity.y += round(gravity * delta)
		
		return velocity


func _clamp_velocity(velocity: Vector2) -> Vector2:
	velocity.x = clamp(velocity.x, -max_speed.x, max_speed.x)
	velocity.y = clamp(velocity.y, -max_speed.y, max_speed.y)
	
	return velocity