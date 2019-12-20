extends KinematicBody2D

export (int) var throw_velocity = 200
export (int) var gravity = 1200

var velocity = Vector2.ZERO

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	var collision = move_and_collide(velocity * delta)
	if collision != null:
		queue_free()

func shoot(direction: Vector2) -> void:
	velocity = throw_velocity * direction