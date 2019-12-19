extends "res://addons/gut/test.gd"

onready var static_wall_2p5d = preload("res://Utils/Physics Bodies/StaticWall2P5D.tscn")

func before_each():
	pass

func after_each():
	for child in get_children():
		child.queue_free()

func before_all():
	pass

func after_all():
	pass

func test_simple_wall():
	var wall: PhysicsBody2P5D = static_wall_2p5d.instance()
	add_child(wall)
	
	var base_shape = [Vector2(-1, -1), Vector2(1, -1),
			Vector2(1, 1), Vector2(-1, 1)]
	wall._base_shape.set_polygon(base_shape)
	wall._set_height(0)
	wall._set_z(0)
	
	yield(yield_for(0.04), YIELD)
	
	assert_eq(wall._top_shape.polygon, wall._base_shape.polygon, "Top not the same as base.")
	assert_eq(wall._volume_shape.polygon, wall._base_shape.polygon, "Volume not the same as base.")
	assert_eq(wall.get_z_pos(), 0)
	assert_eq(wall.get_top_z_pos([]), 0)
	assert_eq(wall.get_height(), 0)
	assert_eq(wall.get_base_shapes(0), [PoolVector2Array(base_shape)], "Base shape not the same as base shape passed.")
	assert_eq(wall.get_base_transform(), Transform2D(0.0, Vector2()))
	
	var height = 20
	var z_pos = 10
	wall._set_height(height)
	wall._set_z(z_pos)
	
	var volume_shape = [Vector2(-1, -1 - height), Vector2(1, -1 - height),
			Vector2(1, 1), Vector2(-1, 1)]
	assert_eq(wall._volume_shape.polygon, PoolVector2Array(volume_shape))
	assert_eq(wall.get_z_pos(), z_pos)
	assert_eq(wall.get_top_z_pos([]), z_pos - height)
	assert_eq(wall.get_height(), height)
	assert_eq(wall.get_base_transform(), Transform2D(0.0, Vector2(0, z_pos)), "Base transform did not update with z pos change.")

func test_polygon_wall():
	var wall: PhysicsBody2P5D = static_wall_2p5d.instance()
	add_child(wall)
	
	var base_shape = [Vector2(-3, -1), Vector2(-1, -3),
			Vector2(1, -1), Vector2(3, -3), Vector2(4, 2),
			Vector2(1, 4), Vector2(1, 2), Vector2(-1, 2)]
	wall._base_shape.set_polygon(base_shape)
	wall._set_height(0)
	wall._set_z(0)
	
	yield(yield_for(0.04), YIELD)
	
	var bounding_box = Geometry2D.bounding_box(base_shape)
	var volume_shape = Geometry2D.rect_to_array(bounding_box)
	assert_eq(wall._top_shape.polygon, PoolVector2Array(base_shape), "Top not the same as base.")
	assert_eq(wall._volume_shape.polygon, PoolVector2Array(volume_shape), "Volume not encompass base.")
	
	var height = 40
	wall._set_height(height)
	
	volume_shape[0] += Vector2(0, -height)
	volume_shape[1] += Vector2(0, -height)
	assert_eq(wall._volume_shape.polygon, PoolVector2Array(volume_shape), "Volume shape did not update with height properly.")