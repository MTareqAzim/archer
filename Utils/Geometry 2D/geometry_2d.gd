class_name Geometry2D

static func area(points: Array) -> float:
	return abs(_area(points))


static func centroid(points: Array) -> Vector2:
	var c_x := 0.0
	var c_y := 0.0
	var area := _area(points)
	
	for i in points.size():
		var next_i = (i + 1) % points.size()
		c_x += (points[i].x + points[next_i].x) * ((points[i].x * points[next_i].y) - (points[next_i].x * points[i].y))
		c_y += (points[i].y + points[next_i].y) * ((points[i].x * points[next_i].y) - (points[next_i].x * points[i].y))
	
	c_x = c_x / (6 * area)
	c_y = c_y / (6 * area)
	return Vector2(c_x, c_y)


static func rotate_about_point(point: Vector2, pivot: Vector2, degrees: float) -> Vector2:
	var sin_angle = sin(deg2rad(degrees))
	var cos_angle = cos(deg2rad(degrees))
	
	var rotated_x = cos_angle * (point.x - pivot.x) + \
			sin_angle * (point.y - pivot.y) + pivot.x
	var rotated_y = -sin_angle * (point.x - pivot.x) + \
			cos_angle * (point.y - pivot.y) + pivot.y
	
	return Vector2(rotated_x, rotated_y)


static func point_in_polygon(point: Vector2, polygon: Array) -> bool:
	var wn = 0
	
	for i in polygon.size():
		var next_i = (i + 1) % polygon.size()
		if polygon[i].y <= point.y:
			if polygon[next_i].y > point.y:
				if clockwise(polygon[i], polygon[next_i], point) < 0:
					wn += 1
				if clockwise(polygon[i], polygon[next_i], point) == 0:
					wn = 1
					break
		elif polygon[next_i].y <= point.y:
			if clockwise(polygon[i], polygon[next_i], point) > 0:
				wn -= 1
			if clockwise(polygon[i], polygon[next_i], point) == 0:
					wn = -1
					break
	
	return wn != 0


static func clockwise(p0: Vector2, p1: Vector2, p2: Vector2) -> float:
	var z = (p1.x - p0.x) * (p2.y - p0.y) - (p1.y - p0.y) * (p2.x - p0.x)
	return z


static func bounding_box(points: Array) -> Rect2:
	var min_x = points[0].x
	var max_x = min_x
	var min_y = points[0].y
	var max_y = min_y
	for point in points:
		min_x = min(min_x, point.x)
		max_x = max(max_x, point.x)
		min_y = min(min_y, point.y)
		max_y = max(max_y, point.y)
	
	var size = Vector2(max_x - min_x, max_y - min_y)
	
	return Rect2(Vector2(min_x, min_y), size)


static func rect_to_array(rect: Rect2) -> Array:
	var points = []
	
	if rect.size == Vector2.ZERO:
		points = [rect.position]
	else:
		points = [rect.position,
				rect.position + Vector2(rect.size.x, 0),
				rect.position + rect.size,
				rect.position + Vector2(0, rect.size.y)]
	
	return points


static func _area(points: Array) -> float:
	var area := 0.0
	
	for i in points.size():
		var next_i = (i + 1) % points.size()
		area += points[i].x * points[next_i].y - points[next_i].x * points[i].y
	
	area = area / 2.0
	return area