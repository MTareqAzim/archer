class_name Collision2D

static func collide_and_get_contacts(shape: Array, global_xform: Transform2D, other_shape: Array, other_global_xform: Transform2D) -> Array:
	return collide_with_motion_and_get_contacts(shape, global_xform, Vector2(), other_shape, other_global_xform, Vector2())


static func collide_with_motion_and_get_contacts(shape: Array, global_xform: Transform2D, motion: Vector2,
		other_shape: Array, other_global_xform: Transform2D, other_motion: Vector2) -> Array:
	var collision_points = []

	for i in shape.size():
		shape[i] = global_xform.xform(shape[i]) + motion
	
	for i in other_shape.size():
		other_shape[i] = other_global_xform.xform(other_shape[i]) + other_motion
	
	#other triangles
	for point in shape:
		if Geometry2D.point_in_polygon(point, other_shape):
			if not collision_points.has(point):
				collision_points.append(point)
	
	#shape triangles
	for point in other_shape:
		if Geometry2D.point_in_polygon(point, shape):
			if not collision_points.has(point):
				collision_points.append(point)
	
	#check line intersections
	for i in shape.size():
		var next_i = (i + 1) % shape.size()
		for j in other_shape.size():
			var next_j = (j + 1) % other_shape.size()
			var intersection_point = Geometry.segment_intersects_segment_2d(shape[i], shape[next_i],
					other_shape[j], other_shape[next_j])
			if intersection_point:
				collision_points.append(intersection_point)
	
	if collision_points:
		collision_points = _sort_points_clockwise(collision_points)
	
	return collision_points


static func collide_and_get_resolution_vector(shape: Array, global_xform: Transform2D, other_shape: Array, other_global_xform: Transform2D) -> Vector2:
	return collide_with_motion_and_get_resolution_vector(shape, global_xform, Vector2(), other_shape, other_global_xform, Vector2())


static func collide_with_motion_and_get_resolution_vector(shape: Array, global_xform: Transform2D, motion: Vector2,
		other_shape: Array, other_global_xform: Transform2D, other_motion: Vector2) -> Vector2:
	
	for i in shape.size():
		shape[i] = global_xform.xform(shape[i]) + motion
	
	for i in other_shape.size():
		other_shape[i] = other_global_xform.xform(other_shape[i]) + other_motion
	
	return resolution_vector(shape, other_shape)


static func resolution_vector(p: Array, q: Array) -> Vector2:
	var neg_p := []
	for point in p:
		 neg_p.append(Vector2(-point.x, -point.y))
	
	var minkowski_sum = _minkowski_sum(neg_p, q)
	var origin = Vector2()
	
	var resolution_vectors = _get_vectors_to_perimeter(origin, minkowski_sum)
	resolution_vectors.sort_custom(CustomSort, "sort_by_length")
	
	var res_vec = Vector2()
	if resolution_vectors:
		res_vec = resolution_vectors[0]
	
	return res_vec


static func _sort_points_clockwise(points: Array) -> Array:
	var p_0: Vector2 = points[0]
	for p_n in points:
		if p_n.y < p_0.y or (p_n.y == p_0.y and p_n.x < p_0.x):
			p_0 = p_n
	
	var sort_points = [[p_0, INF]]
	for p_n in points:
		if p_n != p_0:
			sort_points.append([p_n, abs(p_0.angle_to_point(p_n))])
	sort_points.sort_custom(CustomSort, "sort_by_angle")
	
	var sorted_points = []
	for point in sort_points:
		sorted_points.append(point[0])
	
	return sorted_points


static func _minkowski_sum(p: PoolVector2Array, q: PoolVector2Array) -> PoolVector2Array:
		var m_sum := PoolVector2Array()
		
		for p_n in p:
			for q_n in q:
				m_sum.append(p_n + q_n)
		
		return _convex_hull(m_sum)


static func _convex_hull(p: PoolVector2Array) -> PoolVector2Array:
	var convex_hull: Array = []
	
	var points = _sort_points_clockwise(p)
	
	for point in points:
		while convex_hull.size() > 1 and Geometry2D.clockwise(convex_hull[convex_hull.size() - 2], convex_hull[convex_hull.size() - 1], point) <= 0:
			convex_hull.pop_back()
		convex_hull.append(point)
	
	if convex_hull.size() > 1 and Geometry2D.clockwise(convex_hull[convex_hull.size() - 2], convex_hull[convex_hull.size() - 1], convex_hull[0]) <= 0:
		convex_hull.pop_back()
	
	return PoolVector2Array(convex_hull)


static func _get_vectors_to_perimeter(point: Vector2, polygon: Array) -> Vector2:
	var vectors = []
	
	if Geometry2D.point_in_polygon(point, polygon):
		for i in polygon.size():
			var s1 = polygon[i]
			var s2 = polygon[(i + 1) % polygon.size()]
			var closest_point = Geometry.get_closest_point_to_segment_2d(point, s1, s2)
			var vector_to_perimeter: Vector2 = closest_point - point
			vectors.append(vector_to_perimeter)
	
	return vectors


class CustomSort:
	static func sort_by_angle(a: Array, b: Array) -> bool:
		if a[1] > b[1]:
			return true
		elif a[1] == b[1]:
			if a[0].y == b[0].y:
				if a[0].x < b[0].x:
					return true
		return false
	
	static func sort_by_length(a: Vector2, b: Vector2) -> bool:
		if a.length_squared() < b.length_squared():
			return true
		
		return false