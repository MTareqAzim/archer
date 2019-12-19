extends "res://addons/gut/test.gd"

class TestGeometry2DArea:
	extends "res://addons/gut/test.gd"
	
	func test_area_triangle():
		var triangle = [Vector2(-4, 0), Vector2(0, -6), Vector2(4, 0)]
		var area = Geometry2D.area(triangle)
		assert_eq(area, 24.0, "Area of base 8, height 6 triangle.")
	
	func test_area_irregular_triangle():
		var triangle = [Vector2(-1, 1), Vector2(-5, -7), Vector2(3, -3)]
		var area = Geometry2D.area(triangle)
		assert_eq(area, 24.0, "Area of (-1, 1), (-5, -7), (3, -3) triangle.")
	
	func test_area_square():
		var square = [Vector2(-2, 2), Vector2(2, 2), Vector2(2, -2), Vector2(-2, -2)]
		var area = Geometry2D.area(square)
		assert_eq(area, 16.0, "Area of square.")
	
	func test_area_quad():
		var quad = [Vector2(5.71, 2.6), Vector2(-7.8, -5.2), Vector2(-1.35, 3.1), Vector2(2.7, 9.05)]
		var area = Geometry2D.area(quad)
		assert_almost_eq(area, 52.9275, 0.0001, "Area of a quad.")
	
	func test_area_polygon():
		var polygon = [Vector2(-7, -5), Vector2(-2, -3), Vector2(2, -8), Vector2(6, -3), Vector2(-1, 3),
				Vector2(5, 2), Vector2(2, 9), Vector2(-1, 6), Vector2(-5, 7)]
		var area = Geometry2D.area(polygon)
		assert_eq(area, 116.0, "Area of a polygon.")
	
	func test_area_line():
		var line = [Vector2(0, 0), Vector2(3, 4)]
		var area = Geometry2D.area(line)
		assert_eq(area, 0.0, "Area of a line.")

class TestGeometry2DCentroid:
	extends "res://addons/gut/test.gd"
	
	func test_centroid_triangle():
		var triangle = [Vector2(-4, 0), Vector2(0, -6), Vector2(4, 0)]
		var centroid = Geometry2D.centroid(triangle)
		assert_eq(centroid, Vector2(0, -2), "Centroid of Triangle")
	
	func test_centroid_irregular_triangle():
		var triangle = [Vector2(-1.5, 1.3), Vector2(-5.02, -7.1), Vector2(3.23, -3.6)]
		var centroid = Geometry2D.centroid(triangle)
		assert_almost_eq(centroid, Vector2(-1.0967, -3.1333), Vector2(0.0001, 0.0001), "Centroid of Irregular Triangle")
	
	func test_centroid_square():
		var square = [Vector2(0, 0), Vector2(4, 0), Vector2(4, -4), Vector2(0, -4)]
		var centroid = Geometry2D.centroid(square)
		assert_eq(centroid, Vector2(2, -2), "Centroid of Square")
	
	func test_centroid_regular_hexagon():
		var hexagon = [Vector2(-1, 0), Vector2(-1/2, sqrt(3)/2), Vector2(1/2, sqrt(3)/2),
				Vector2(1, 0), Vector2(1/2, -sqrt(3)/2), Vector2(-1/2, -sqrt(3)/2)]
		var center = Vector2(5.22, 3.6)
		hexagon = _translate(hexagon, center)
		var centroid = Geometry2D.centroid(hexagon)
		assert_eq(centroid, center, "Centroid of a regular hexagon")
	
	func _translate(points: Array, translation: Vector2) -> Array:
		var translated_points = []
		for point in points:
			translated_points.append(point + translation)
		
		return translated_points

class TestGeometry2DRotateAboutPoint:
	extends "res://addons/gut/test.gd"
	
	func test_rotate_about_origin():
		var point = Vector2(1, 0)
		var pivot = Vector2()
		
		var rotated_point = Geometry2D.rotate_about_point(point, pivot, 90.0)
		assert_almost_eq(rotated_point.x, 0.0, 0.00001, str(rotated_point) + " not close to (0, -1)")
		assert_almost_eq(rotated_point.y, -1.0, 0.00001, str(rotated_point) + " not close to (0, -1)")
		
		rotated_point = Geometry2D.rotate_about_point(point, pivot, 45.0)
		assert_eq(rotated_point, Vector2(sqrt(2)/2, -sqrt(2)/2))
		
		rotated_point = Geometry2D.rotate_about_point(point, pivot, -135.0)
		assert_eq(rotated_point, Vector2(-sqrt(2)/2, sqrt(2)/2))
	
	func test_rotate_about_point():
		var point = Vector2(6, 4)
		var pivot = Vector2(5, 4)
		
		var rotated_point = Geometry2D.rotate_about_point(point, pivot, 90.0)
		assert_eq(rotated_point, Vector2(5, 3))
		
		rotated_point = Geometry2D.rotate_about_point(point, pivot, 45.0)
		assert_eq(rotated_point, Vector2(5 + sqrt(2)/2, 4 -sqrt(2)/2))
		
		rotated_point = Geometry2D.rotate_about_point(point, pivot, -135.0)
		assert_eq(rotated_point, Vector2(5 -sqrt(2)/2, 4 + sqrt(2)/2))

class TestGeometry2DPointInPolygon:
	extends "res://addons/gut/test.gd"
	
	func test_point_in_square():
		var square = [Vector2(0, 0), Vector2(4, 0), Vector2(4, -4), Vector2(0, -4)]
		var point_inside = Vector2(1, -3)
		assert_true(Geometry2D.point_in_polygon(point_inside, square), "Point inside.")
		
		var point_on_edge = Vector2(4, -1)
		assert_true(Geometry2D.point_in_polygon(point_on_edge, square), "Point on edge.")
		
		var point_outside = Vector2(23, 5)
		assert_false(Geometry2D.point_in_polygon(point_outside, square), "Point outside.")
	
	func test_point_in_polygon():
		var polygon = [Vector2(-7, -5), Vector2(-2, -3), Vector2(2, -7), Vector2(6, -3), Vector2(-1, 3),
				Vector2(5, 2), Vector2(2, 9), Vector2(-1, 6), Vector2(-5, 7)]
		var point_inside = Vector2(-3, 2)
		assert_true(Geometry2D.point_in_polygon(point_inside, polygon), "Point inside.")
		
		var point_on_edge = Vector2(1, 8)
		assert_true(Geometry2D.point_in_polygon(point_on_edge, polygon), "Point on edge.")
		
		var point_outside = Vector2(1, 2)
		assert_false(Geometry2D.point_in_polygon(point_outside, polygon), "Point outside.")

class TestGeometry2DClockwise:
	extends "res://addons/gut/test.gd"
	
	func test_clockwise():
		var point_a = Vector2(0, 0)
		var point_b = Vector2(0, -1)
		var clockwise = Vector2(1, -2)
		assert_true(Geometry2D.clockwise(point_a, point_b, clockwise) > 0, "Turn is clockwise.")
		
		var counterclockwise = Vector2(-1, -2)
		assert_true(Geometry2D.clockwise(point_a, point_b, counterclockwise) < 0, "Turn is counterclockwise.")
		
		var straight = Vector2(0, -2)
		assert_true(Geometry2D.clockwise(point_a, point_b, straight) == 0, "Turn is straight.")

class TestGeometry2DBoundingRect:
	extends "res://addons/gut/test.gd"
	
	func test_bounding_box_one_point():
		var point = [Vector2(1, 1)]
		var bounding_box = Geometry2D.bounding_box(point)
		var expected_box = Rect2(point[0], Vector2(0, 0))
		assert_eq(bounding_box, expected_box)
	
	func test_bounding_box_many_points():
		var points = [Vector2(-6, 1), Vector2(-3, -4), Vector2(-1, -1),
				Vector2(1, 0), Vector2(3, -2), Vector2(6, -6),
				Vector2(5, -1), Vector2(2, 2), Vector2(-3, 4)]
		var bounding_box = Geometry2D.bounding_box(points)
		var expected_box = Rect2(Vector2(-6, -6), Vector2(12, 10))
		assert_eq(bounding_box, expected_box)

class TestGeometry2DRectToArray:
	extends "res://addons/gut/test.gd"
	
	func test_empty_rect():
		var rect = Rect2(Vector2(), Vector2())
		var array = Geometry2D.rect_to_array(rect)
		
		assert_eq(array, [Vector2()], "Size 0 rect not returning a point.")
	
	func test_unit_square():
		var rect = Rect2(Vector2(), Vector2(1, 1))
		var array = Geometry2D.rect_to_array(rect)
		
		var expected_points = [Vector2(0, 0), Vector2(1, 0),
				Vector2(1, 1), Vector2(0, 1)]
		assert_eq(array, expected_points, "Unit square at position (0,0) not being returned")
	
	func test_rectangle():
		var rect = Rect2(Vector2(-3, -5), Vector2(20, 7))
		var array = Geometry2D.rect_to_array(rect)
		
		var expected_points = [Vector2(-3, -5), Vector2(17, -5),
				Vector2(17, 2), Vector2(-3, 2)]
		assert_eq(array, expected_points)
	
	func test_negative_size():
		var rect = Rect2(Vector2(3, 3), Vector2(-4, -6))
		var array = Geometry2D.rect_to_array(rect)
		
		var expected_points = [Vector2(3, 3), Vector2(-1, 3),
				Vector2(-1, -3), Vector2(3, -3)]
		assert_eq(array, expected_points)