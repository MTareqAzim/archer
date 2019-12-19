extends "res://addons/gut/test.gd"

func before_each():
	pass

func after_each():
	for child in get_children():
		child.queue_free()

func before_all():
	pass

func after_all():
	pass

func test_simple_quad():
	var polygon = [Vector2(-1, -1), Vector2(1, -1),
			Vector2(1, 1), Vector2(-1, 1)]
	var composite_polygon_2d := CompositePolygon2D.new()
	add_child(composite_polygon_2d)
	composite_polygon_2d.set_polygon(polygon)
	assert_eq(composite_polygon_2d.polygons, [PoolVector2Array(polygon)])

func test_concave_polygon():
	var polygon = [Vector2(-1, -1), Vector2(0, 0),
			Vector2(1, -1), Vector2(1, 1), Vector2(-1, 1)]
	var composite_polygon_2d := CompositePolygon2D.new()
	add_child(composite_polygon_2d)
	composite_polygon_2d.set_polygon(polygon)
	assert_gt(composite_polygon_2d.polygons.size(), 1, "Not simplifying cocave polygon.")

func test_convex_polygon():
	var polygon = [Vector2(-1, -1), Vector2(0, -2),
			Vector2(1, -1), Vector2(1, 1), Vector2(-1, 1)]
	var composite_polygon_2d := CompositePolygon2D.new()
	add_child(composite_polygon_2d)
	composite_polygon_2d.set_polygon(polygon)
	assert_eq(composite_polygon_2d.polygons, [PoolVector2Array(polygon)], "Breaking up convex polygons.")