tool
extends Polygon2D
class_name CompositePolygon2D

signal polygon_changed


func _ready() -> void:
	_visualize_components()


func get_class() -> String:
	return "CompositePolygon2D"


func is_class(type: String) -> bool:
	return type == "CompositePolygon2D" or .is_class(type)


func set_polygon(polygon: PoolVector2Array) -> void:
	.set_polygon(polygon)
	_convex_decomposition()
	_visualize_components()
	emit_signal("polygon_changed")


func _convex_decomposition() -> void:
	var convex_shapes = []
	var area_2d := Area2D.new()
	var collision_shape := CollisionPolygon2D.new()
	
	area_2d.add_child(collision_shape)
	collision_shape.polygon = polygon
	
	for shape_owner in area_2d.get_shape_owners():
		for shape_id in area_2d.shape_owner_get_shape_count(shape_owner):
			var shape = area_2d.shape_owner_get_shape(shape_owner, shape_id)
			convex_shapes.append(shape.points)
	
	polygons = convex_shapes
	area_2d.queue_free()


func _visualize_components() -> void:
	for child in get_children():
		child.queue_free()
	
	for index in polygons.size():
		var shape = Polygon2D.new()
		add_child(shape)
		shape.polygon = polygons[index]
		shape.color = color * (1.0 - (index * 1.0 / polygons.size()))
		shape.color.a = 0.5