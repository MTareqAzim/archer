extends KinematicBody2D

export (int) var throw_velocity = 200
export (int) var gravity = 1200

onready var hit_box = $"Hit Box"
onready var sprite = $Collider/Arrow
onready var collider = $Collider
var velocity = Vector2.ZERO

var _distance_traveled : float = 0.0

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	
	collider.rotation = velocity.angle()
	
	_distance_traveled += (velocity * delta).length()
	
	var collision = move_and_collide(velocity * delta)
	if collision != null:
		_on_hit(collision)
	
	var boss = hit_box.get_overlapping_bodies()
	if boss:
		_hit_boss(boss[0])
	
	if _distance_traveled > 2000:
		queue_free()


func get_distance_travelled() -> float:
	return _distance_traveled


func shoot(direction: Vector2) -> void:
	velocity = throw_velocity * direction


func _on_hit(collision: KinematicCollision2D) -> void:
	var rotation = collider.rotation
	var transform = sprite.global_transform
	collider.remove_child(sprite)
	
	sprite.global_transform = transform
	sprite.rotation = rotation
	collision.get_collider().add_child(sprite)
	
	queue_free()


func _hit_boss(boss: KinematicBody2D) -> void:
	var rotation = collider.rotation
	var transform = sprite.global_transform
	collider.remove_child(sprite)
	
	boss.add_child(sprite)
	sprite.global_transform = transform
	sprite.rotation = rotation
	
	queue_free()