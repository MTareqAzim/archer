tool
extends StaticBody2P5D
class_name StaticWall2P5D, "static_wall_2p5d.png"

onready var _base_shape = $BaseShape
onready var _top_shape = $TopShape
onready var _volume_shape = $VolumeShape
onready var _dist_to_ground = $DistToGround
onready var _ready := true

export (int) var _z_pos: = 0 setget _set_z, get_z_pos
export (int) var _height: = 0 setget _set_height, get_height


func get_class() -> String:
	return "StaticWall2P5D"


func is_class(type: String) -> bool:
	return type == "StaticWall2P5D" or .is_class(type)


func get_z_pos() -> int:
	return _z_pos


func get_height() -> int:
	return _height


func get_base_shapes(z_pos: int) -> Array:
	if z_pos < _z_pos - _height or z_pos > _z_pos:
		return []
	
	return _base_shape.get_polygons()


func get_base_transform() -> Transform2D:
	return _base_shape.get_global_transform()


func get_top_z_pos(points: Array) -> int:
	return _z_pos - _height


func _set_z(new_z: int) -> void:
	var diff = _z_pos - new_z
	_z_pos = new_z
	
	if _ready:
		translate(Vector2(0, -diff))
		_update_dist_to_ground()


func _set_height(new_height: int) -> void:
	_height = new_height
	_update_components()


#Editor functions
func _update_components() -> void:
	if not _ready:
		return
	
	_update_top()
	_update_volume()


func _update_volume() -> void:
	var points: Array = _base_shape.get_polygon()
	var bounding_box: Rect2 = Geometry2D.bounding_box(points)
	
	var vector_array = Geometry2D.rect_to_array(bounding_box)
	vector_array[0] += Vector2(0, -_height)
	vector_array[1] += Vector2(0, -_height)
	
	_volume_shape.set_polygon(vector_array)
	_volume_shape.set_position(_base_shape.get_position())


func _update_top() -> void:
	_top_shape.set_polygon(_base_shape.get_polygon())
	_top_shape.set_position(_base_shape.get_position() - Vector2(0, _height))


func _update_dist_to_ground() -> void:
	_dist_to_ground.set_cast_to(Vector2(0, -_z_pos))
	_dist_to_ground.set_visible(_dist_to_ground.cast_to != Vector2.ZERO)


func _on_CompositePolygon2D_polygon_changed() -> void:
	if _ready:
		call_deferred("_update_components")
