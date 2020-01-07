extends KinematicBody2D

export (int) var throw_velocity = 200
export (int) var gravity = 1200

var velocity = Vector2.ZERO

var _distance_traveled : float = 0.0

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	
	$Collider.rotation = velocity.angle()
	
	_distance_traveled += (velocity * delta).length()
	
	var collision = move_and_collide(velocity * delta)
	if collision != null:
		set_physics_process(false)


func get_distance_travelled() -> float:
	return _distance_traveled


func shoot(direction: Vector2) -> void:
	velocity = throw_velocity * direction