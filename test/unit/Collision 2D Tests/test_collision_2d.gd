extends "res://addons/gut/test.gd"

class TestCollision2DNonCollidingObjects:
	extends "res://addons/gut/test.gd"
	
	var object_a
	var object_a_transform
	
	var object_b
	var object_b_transform
	
	func before_each():
		object_a = [Vector2(-3, -10), Vector2(-4, -6), Vector2(-1, -4), Vector2(-3, -2),
				Vector2(-8, -2), Vector2(-11, -4), Vector2(-8, -8)]
		object_a_transform = Transform2D()
		
		object_b = [Vector2(5, 2), Vector2(7, 4), Vector2(6, 6),
				Vector2(4, 6), Vector2(3, 4)]
		object_b_transform = Transform2D()
	
	func test_collide_and_get_contacts():
		var contact_points = Collision2D.collide_and_get_contacts(
				object_a,
				object_a_transform, 
				object_b,
				object_b_transform)
		
		assert_eq(contact_points, [], "No contact points.")
	
	func test_collide_with_motion_and_get_contacts():
		var contact_points = Collision2D.collide_with_motion_and_get_contacts(
				object_a,
				object_a_transform,
				Vector2(-3, 2), 
				object_b,
				object_b_transform,
				Vector2(4, -5))
		
		assert_eq(contact_points, [], "No contact points.")
	
	func test_collide_and_get_resolution_vector():
		var resolution_vector = Collision2D.collide_and_get_resolution_vector(
				object_a,
				object_a_transform, 
				object_b,
				object_b_transform)
		
		assert_eq(resolution_vector, Vector2(), "No resolution vector.")
	
	func test_collide_with_motion_and_get_resolution_vector():
		var resolution_vector = Collision2D.collide_with_motion_and_get_resolution_vector(
				object_a,
				object_a_transform,
				Vector2(-3, 2), 
				object_b,
				object_b_transform,
				Vector2(4, -5))
		
		assert_eq(resolution_vector, Vector2(), "No resolution vector.")

class TestCollision2DCollidingObjects:
	extends "res://addons/gut/test.gd"
	
	var object_a
	var object_a_transform
	
	var object_b
	var object_b_transform
	
	func before_each():
		object_a = [Vector2(-4, 5), Vector2(3, 5), 
				Vector2(3, 11), Vector2(-4, 11)]
		object_a_transform = Transform2D()
		
		object_b = [Vector2(1, 1), Vector2(7, 1),
				Vector2(7, 6), Vector2(1, 6)]
		object_b_transform = Transform2D()
	
	func test_collide_and_get_contacts():
		var contact_points = Collision2D.collide_and_get_contacts(
				object_a,
				object_a_transform, 
				object_b,
				object_b_transform)
		
		var expected_points = [Vector2(1, 5), Vector2(3, 5),
			Vector2(3, 6), Vector2(1, 6)]
		
		assert_eq(contact_points, expected_points)
	
	func test_collide_with_motion_and_get_contacts():
		var contact_points = Collision2D.collide_with_motion_and_get_contacts(
				object_a,
				object_a_transform,
				Vector2(3, -1), 
				object_b,
				object_b_transform,
				Vector2(0, 1))
		
		var expected_points = [Vector2(1, 4), Vector2(6, 4), Vector2(6, 7), Vector2(1, 7)]
		
		assert_eq(contact_points, expected_points)
	
	func test_collide_and_get_resolution_vector():
		var resolution_vector = Collision2D.collide_and_get_resolution_vector(
				object_a,
				object_a_transform, 
				object_b,
				object_b_transform)
		
		assert_eq(resolution_vector, Vector2(0, 1))
	
	func test_collide_with_motion_and_get_resolution_vector():
		var resolution_vector = Collision2D.collide_with_motion_and_get_resolution_vector(
				object_a,
				object_a_transform,
				Vector2(2, -1), 
				object_b,
				object_b_transform,
				Vector2(0, 1))
		
		assert_eq(resolution_vector, Vector2(0, 3))