tool
extends PhysicsBody2P5D
class_name KinematicBody2P5D, "kinematic_body_2p5d.png"

onready var _ready := true
onready var _base_shape : Polygon2D = $BaseShape

const SKIN_WIDTH := 1
const BASE_SKIN_RADIUS := 8
const VOLUME_SKIN_WIDTH := 5
const FLOOR_SKIN_RADIUS := 15
const GLOBAL_GROUND := 0

export (int) var MAX_SPEED := 1000
export (int) var GRAVITY := 980 setget set_grav, get_grav
export (int) var _height := 0 setget set_height, get_height
export (int) var _z_pos := 0 setget set_z_pos, get_z_pos

var STEP_HEIGHT_LIMIT := 10

var _velocity := Vector3() setget set_velocity, get_velocity

func _physics_process(delta: float) -> void:
	_velocity = _apply_gravity(_velocity, delta)
	_velocity = _clamp_velocity(_velocity)
	
	var delta_movement = (_velocity * delta).round()
	delta_movement = _handle_collisions(delta_movement, delta)
	
	translate(Vector2(delta_movement.x, delta_movement.y + delta_movement.z))
	_z_pos += delta_movement.z


func get_class() -> String:
	return "KinematicBody2P5D"


func is_class(type: String) -> bool:
	return type == "KinematicBody2P5D" or .is_class(type)


func set_grav(new_grav: int) -> void:
	GRAVITY = new_grav


func get_grav() -> int:
	return GRAVITY


func set_height(new_height: int) -> void:
	_height = new_height
	_update_volume_shape()


func get_height() -> int:
	return _height


func set_z_pos(new_z_pos: int) -> void:
	var diff = _z_pos - new_z_pos
	_z_pos = new_z_pos
	
	if _ready:
		translate(Vector2(0, -diff))


func get_z_pos() -> int:
	return _z_pos


func set_velocity(new_velocity: Vector3) -> void:
	_velocity = new_velocity


func get_velocity() -> Vector3:
	return _velocity


func set_velocity_2d(velocity_2d) -> void:
	_velocity.x = velocity_2d.x
	_velocity.y = velocity_2d.y


func get_velocity_2d() -> Vector2:
	return Vector2(_velocity.x, _velocity.y)


func set_z_velocity(z_velocity: int) -> void:
	_velocity.z = z_velocity


func get_z_velocity() -> int:
	return int(_velocity.z)


func get_base_shapes(z_pos: int) -> Array:
	if z_pos < _z_pos - _height or z_pos > _z_pos:
		return []
	
	return _base_shape.get_polygons()


func get_base_transform() -> Transform2D:
	return _base_shape.get_global_transform()


func get_top_z_pos(points: Array) -> int:
	return _z_pos


func is_grounded() -> bool:
	if _is_on_floor():
		return true
	
	if _z_pos == GLOBAL_GROUND:
		return true
	
	return false


func _is_on_floor() -> bool:
	for collision in get_overlapping_areas():
		var collision_z_pos = collision.get_z_pos()
		var collision_transform = collision.get_base_transform()
		var height_diff = collision_z_pos - _z_pos
		
		if _z_pos <= collision_z_pos and _z_pos >= collision_z_pos - collision.get_height():
			for collision_shape in collision.get_base_shapes(collision_z_pos):
				var collision_points = _get_base_collision_points(Vector2(), collision_shape, collision_transform, height_diff)
				if collision_points:
					var floor_pos = collision.get_top_z_pos(collision_points)
					if _z_pos == floor_pos:
						return true
	
	return false


func _apply_gravity(velocity: Vector3, delta: float) -> Vector3:
	if not is_grounded():
		velocity.z += round(GRAVITY * delta)
	
	if is_grounded() and velocity.z > 0:
		velocity.z = 0
	
	return velocity


func _clamp_velocity(velocity: Vector3) -> Vector3:
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	velocity.y = clamp(velocity.y, -MAX_SPEED, MAX_SPEED)
	velocity.z = clamp(velocity.z, -MAX_SPEED, MAX_SPEED)
	
	return velocity


func _handle_collisions(delta_movement: Vector3, delta: float) -> Vector3:
	delta_movement = _handle_steps(delta_movement)
	delta_movement = _handle_floor_collisions(delta_movement)
	delta_movement = _handle_wall_collisions(delta_movement, delta)
	
	return delta_movement


func _handle_steps(delta_movement: Vector3) -> Vector3:
	var closest_floor_dist := 0
	
	if delta_movement.z >= 0:
		var closest_step_down_dist = _get_closest_step_down_dist(delta_movement)
		if closest_step_down_dist != 0:
			closest_floor_dist = closest_step_down_dist
	
	if delta_movement.z <= 0:
		var closest_step_up_dist = _get_closest_step_up_dist(delta_movement)
		if closest_step_up_dist != 0:
			closest_floor_dist = closest_step_up_dist
	
	delta_movement.z += closest_floor_dist
	
	return delta_movement


func _get_closest_step_down_dist(delta_movement: Vector3) -> int:
	var closest_floor_dist := 0
	var future_z_pos = _z_pos + delta_movement.z
	
	var dist_to_global_ground = GLOBAL_GROUND - future_z_pos
	if abs(dist_to_global_ground) <= STEP_HEIGHT_LIMIT:
		closest_floor_dist = dist_to_global_ground
	
	for floor_pos in _get_floor_positions(delta_movement):
		if floor_pos == future_z_pos:
			closest_floor_dist = 0
			break
		elif future_z_pos < floor_pos:
			var dist_to_floor = floor_pos - future_z_pos
			if abs(dist_to_floor) <= STEP_HEIGHT_LIMIT:
				if closest_floor_dist == 0:
					closest_floor_dist = dist_to_floor
				else:
					closest_floor_dist = min(closest_floor_dist, dist_to_floor)
	
	return closest_floor_dist


func _get_closest_step_up_dist(delta_movement: Vector3) -> int:
	var closest_floor_dist := 0
	var future_z_pos = _z_pos + delta_movement.z
	
	for floor_pos in _get_floor_positions(delta_movement):
		if future_z_pos >= floor_pos:
			var dist_to_floor = floor_pos - future_z_pos
			if abs(dist_to_floor) <= STEP_HEIGHT_LIMIT:
				closest_floor_dist = min(closest_floor_dist, dist_to_floor)
	
	return closest_floor_dist


func _handle_floor_collisions(delta_movement: Vector3) -> Vector3:
	var closest_floor_dist = GLOBAL_GROUND - _z_pos
	
	for floor_pos in _get_floor_positions(delta_movement):
		var dist_to_floor = floor_pos - _z_pos
		if abs(dist_to_floor) < abs(closest_floor_dist):
			closest_floor_dist = dist_to_floor
	
	if (delta_movement.z > 0) and (delta_movement.z > closest_floor_dist):
		delta_movement.z = closest_floor_dist
	
	return delta_movement


func _get_floor_positions(delta_movement: Vector3) -> Array:
	var floor_positions := []
	var delta_movement_2d = Vector2(delta_movement.x, delta_movement.y)
	
	for collision in get_overlapping_areas():
		var collision_z_pos = collision.get_z_pos()
		var collision_transform = collision.get_base_transform()
		var height_diff = collision_z_pos - _z_pos
		
		for collision_shape in collision.get_base_shapes(collision_z_pos):
			var collision_points = _get_base_collision_points(delta_movement_2d, collision_shape, collision_transform, height_diff)
			if collision_points:
				var floor_position = collision.get_top_z_pos(collision_points)
				floor_positions.append(floor_position)
	
	return floor_positions


func _get_base_collision_points(delta_movement_2D: Vector2, other_base: Array, other_transform: Transform2D, height_diff: int) -> Array:
	var base_shape = $BaseShape
	var base_transform = base_shape.get_global_transform().translated(Vector2(0, height_diff))
	
	var collision_points = Collision2D.collide_with_motion_and_get_contacts(
			base_shape.polygon,
			base_transform,
			delta_movement_2D,
			other_base,
			other_transform,
			Vector2())
	
	return collision_points


func _handle_wall_collisions(delta_movement: Vector3, delta: float) -> Vector3:
	for collision in get_overlapping_areas():
		var collision_z_pos = collision.get_z_pos()
		var collision_transform = collision.get_base_transform()
		var future_z_pos = _z_pos + delta_movement.z
		var height_diff = collision_z_pos - _z_pos
		
		if future_z_pos <= collision_z_pos and future_z_pos > collision_z_pos - collision.get_height():
			for collision_shape in collision.get_base_shapes(future_z_pos):
				delta_movement = _handle_base_collision(delta_movement, delta, collision_shape, collision_transform, height_diff)
		elif collision_z_pos <= future_z_pos and collision_z_pos > future_z_pos - _height:
			for collision_shape in collision.get_base_shapes(collision_z_pos):
				delta_movement = _handle_base_collision(delta_movement, delta, collision_shape, collision_transform, height_diff)
	
	return delta_movement


func _handle_base_collision(delta_movement: Vector3, delta: float, other_base: Array, other_transform: Transform2D, height_diff: int) -> Vector3:
	var delta_movement_2D = Vector2(delta_movement.x, delta_movement.y)
	
	var knockback = _get_base_resolution_vector(delta_movement_2D, other_base, other_transform, height_diff)
	delta_movement_2D += knockback
	
	delta_movement = Vector3(delta_movement_2D.x, delta_movement_2D.y, delta_movement.z)
	delta_movement = _clamp_delta_movement(delta_movement, delta)
	
	return delta_movement


func _get_base_resolution_vector(delta_movement_2D: Vector2, other_base: Array, other_transform: Transform2D, height_diff: int) -> Vector2:
	var base_shape = $BaseShape
	var base_transform = base_shape.get_global_transform().translated(Vector2(0, height_diff))
	
	var res_vec = Collision2D.collide_with_motion_and_get_resolution_vector(
			base_shape.polygon,
			base_transform,
			delta_movement_2D,
			other_base,
			other_transform,
			Vector2())
	
	return res_vec


func _clamp_delta_movement(delta_movement: Vector3, delta: float) -> Vector3:
	delta_movement.x = clamp(delta_movement.x, -MAX_SPEED * delta, MAX_SPEED * delta)
	delta_movement.y = clamp(delta_movement.y, -MAX_SPEED * delta, MAX_SPEED * delta)
	delta_movement.z = clamp(delta_movement.z, -MAX_SPEED * delta, MAX_SPEED * delta)
	
	return delta_movement.round()


#Editor Functions
func _update_base_skin() -> void:
	var base_skin = $BaseSkin
	var base_shape = $BaseShape.get_polygon()
	
	var bounding_box = Geometry2D.bounding_box(base_shape)
	var extents = bounding_box.size / 2.0
	
	base_skin.shape.set_radius(BASE_SKIN_RADIUS + max(extents.x, extents.y))
	base_skin.set_position(Geometry2D.centroid(base_shape))


func _update_volume_shape() -> void:
	var volume_shape = $VolumeShape
	var base_shape = $BaseShape.get_polygon()
	
	var bounding_box = Geometry2D.bounding_box(base_shape)
	var extents = bounding_box.size / 2.0
	
	volume_shape.shape.set_extents(extents + Vector2(0, _height/2.0) + Vector2(VOLUME_SKIN_WIDTH, VOLUME_SKIN_WIDTH))
	volume_shape.set_position(Geometry2D.centroid(base_shape) - Vector2(0, _height/2.0))


func _on_BaseShape_polygon_changed():
	if Engine.is_editor_hint():
		call_deferred("_update_base_skin")
		call_deferred("_update_volume_shape")
