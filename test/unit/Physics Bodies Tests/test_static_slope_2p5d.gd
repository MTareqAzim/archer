extends "res://addons/gut/test.gd"

onready var static_slope_2p5d = preload("res://Utils/Physics Bodies/StaticSlope2P5D.tscn")

func before_each():
	pass

func after_each():
	for child in get_children():
		child.queue_free()

func before_all():
	pass

func after_all():
	pass

class TestStaticSlope2P5DSimpleSlope:
	extends "res://addons/gut/test.gd"
	
	onready var static_slope_2p5d = preload("res://Utils/Physics Bodies/StaticSlope2P5D.tscn")
	var slope : PhysicsBody2P5D
	var height = 10
	var length = 10
	var width = 10
	
	func before_each():
		slope._set_height(10)
		slope._set_length(10)
		slope._set_width(10)
		slope._set_angle(0)
	
	func before_all():
		slope = static_slope_2p5d.instance()
		add_child(slope)
	
	func after_all():
		for child in get_children():
			child.queue_free()
	
	func test_simple_slope_polygons():
		var expected_base = [Vector2(-5, -5), Vector2(5, -5),
				Vector2(5, 5), Vector2(-5, 5)]
		assert_eq(slope._base_shape.polygon, PoolVector2Array(expected_base))
		
		var expected_top = expected_base
		expected_top[0] += Vector2(0, -height)
		expected_top[1] += Vector2(0, -height)
		assert_eq(slope._top_shape.polygon, PoolVector2Array(expected_top))
	
	func test_simple_slope_functions():
		assert_eq(slope.get_z_pos(), 0)
		assert_eq(slope.get_height(), height)
		
		var expected_base = [Vector2(-5, -5), Vector2(5, -5),
				Vector2(5, 5), Vector2(-5, 5)]
		assert_eq(slope.get_base_shapes(0), [PoolVector2Array(expected_base)])
		
		assert_eq(slope.get_base_transform(), Transform2D(0.0, Vector2()))
		
	func test_simple_slope_get_base_shapes():
		var test_z_pos = -height * 0.25
		var expected_base = [Vector2(-5, -5), Vector2(5, -5),
				Vector2(5, 3), Vector2(-5, 3)]
		assert_eq(slope.get_base_shapes(test_z_pos), [expected_base], "Should return 75% base rounded.")
		
		test_z_pos = -height * 0.5
		expected_base = [Vector2(-5, -5), Vector2(5, -5),
				Vector2(5, 0), Vector2(-5, 0)]
		assert_eq(slope.get_base_shapes(test_z_pos), [expected_base], "Should return 50% base rounded.")
		
		test_z_pos = -height * 0.8
		expected_base = [Vector2(-5, -5), Vector2(5, -5),
				Vector2(5, -3), Vector2(-5, -3)]
		assert_eq(slope.get_base_shapes(test_z_pos), [expected_base], "Should return 20% base rounded.")
		
		test_z_pos = -height * 1.0
		assert_eq(slope.get_base_shapes(test_z_pos), [], "Should return no base at top.")
	
	func test_simple_slope_get_top_z_pos():
		var test_position = Vector2(0, 5) #Base of slope
		var expected_top_z_pos = -height * 0
		assert_eq(slope.get_top_z_pos([test_position]), expected_top_z_pos, "Should return 0 when at base.")
		
		test_position = Vector2(0, 2.5) #Quarter way up slope
		expected_top_z_pos = int(round(-height * 0.25))
		assert_eq(slope.get_top_z_pos([test_position]), expected_top_z_pos, "Should return 25% rounded height when quarter way up slope.")
		
		test_position = Vector2(0, 0) #Half way up slope
		expected_top_z_pos = int(round(-height * 0.5))
		assert_eq(slope.get_top_z_pos([test_position]), expected_top_z_pos, "Should return 50% rounded height when quarter way up slope.")
		
		test_position = Vector2(0, -3) #80% up slope
		expected_top_z_pos = int(round(-height * 0.8))
		assert_eq(slope.get_top_z_pos([test_position]), expected_top_z_pos, "Should return 80% rounded height when quarter way up slope.")