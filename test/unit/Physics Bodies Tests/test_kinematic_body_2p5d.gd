extends "res://addons/gut/test.gd"

onready var kinematic_body_2p5d = preload("res://Utils/Physics Bodies/KinematicBody2P5D.tscn")

var body : KinematicBody2P5D = null

func before_each():
	body = kinematic_body_2p5d.instance()
	body.set_height(100)
	body.set_position(Vector2(0, 0))
	body.set_velocity(Vector3())
	add_child(body)

func after_each():
	for child in get_children():
		child.queue_free()

func before_all():
	pass

func after_all():
	pass


func test_set_z_pos() -> void:
	body.set_grav(0)
	assert_eq(body.get_position(), Vector2(0, 0), "Body position not zeroed.")
	
	body.set_z_pos(-10)
	assert_eq(body.get_position(), Vector2(0, -10), "Body not set to proper z position.")
	
	body.set_z_pos(10)
	assert_eq(body.get_position(), Vector2(0, 10), "Body not set to proper z position.")

func test_set_velocity() -> void:
	body.set_grav(0)
	
	var velocity = Vector3(100, 0, 0)
	body.set_velocity(velocity)
	assert_eq(body.get_velocity(), velocity, "Velocity not updated")
	gut.simulate(body, 1, 0.1)
	assert_eq(body.get_position(), Vector2(10, 0), "Body did not move in x direction.")
	
	body.set_position(Vector2(0, 0))
	velocity = Vector3(0, 100, 0)
	body.set_velocity(velocity)
	assert_eq(body.get_velocity(), velocity, "Velocity not updated")
	gut.simulate(body, 1, 0.1)
	assert_eq(body.get_position(), Vector2(0, 10), "Body did not move in y direction.")
	
	body.set_position(Vector2(0, 0))
	velocity = Vector3(0, 0, -100)
	body.set_velocity(velocity)
	assert_eq(body.get_velocity(), velocity, "Velocity not updated")
	gut.simulate(body, 1, 0.1)
	assert_eq(body.get_position(), Vector2(0, -10), "Body did not move in z direction.")
	assert_eq(body.get_z_pos(), -10, "Body did not move in z direction.")
	
	body.set_z_pos(0)
	body.set_position(Vector2(0, 0))
	velocity = Vector3(0, 0, 100)
	body.set_velocity(velocity)
	assert_eq(body.get_velocity(), velocity, "Velocity not updated")
	gut.simulate(body, 1, 0.1)
	assert_eq(body.get_position(), Vector2(0, 0), "Body fell below global ground.")
	assert_eq(body.get_z_pos(), 0, "Body fell below global ground.")

func test_set_velocity_2d() -> void:
	body.set_grav(0)
	
	var velocity = Vector2(100, 0)
	body.set_velocity_2d(velocity)
	assert_eq(body.get_velocity_2d(), velocity, "Velocity not updated")
	gut.simulate(body, 1, 0.1)
	assert_eq(body.get_position(), Vector2(10, 0), "Body did not move in x direction.")
	
	body.set_position(Vector2(0, 0))
	velocity = Vector2(0, 100)
	body.set_velocity_2d(velocity)
	assert_eq(body.get_velocity_2d(), velocity, "Velocity not updated")
	gut.simulate(body, 1, 0.1)
	assert_eq(body.get_position(), Vector2(0, 10), "Body did not move in y direction.")
	
	body.set_position(Vector2(0, 0))
	velocity = Vector2(-100, -100)
	body.set_velocity_2d(velocity)
	assert_eq(body.get_velocity_2d(), velocity, "Velocity not updated")
	gut.simulate(body, 1, 0.1)
	assert_eq(body.get_position(), Vector2(-10, -10), "Body did not move.")

func test_set_z_velocity() -> void:
	body.set_grav(0)
	
	body.set_z_pos(-100)
	body.set_z_velocity(100)
	gut.simulate(body, 1, 0.1)
	assert_eq(body.get_z_pos(), -90, "Body didn't move down in z direction.")
	assert_eq(body.get_position(), Vector2(0, -90), "Body didn't move down in z direction.")
	
	body.set_z_pos(0)
	body.set_z_velocity(-100)
	gut.simulate(body, 1, 0.1)
	assert_eq(body.get_z_pos(), -10, "Body didn't move up in z direction.")
	assert_eq(body.get_position(), Vector2(0, -10), "Body didn't move down in z direction.")

func test_is_grounded() -> void:
	body.set_grav(0)
	
	assert_eq(body.is_grounded(), true, "Body on global ground not grounded.")
	
	body.set_z_pos(-10)
	assert_eq(body.is_grounded(), false, "Body in air is grounded.")
	
	body.set_z_pos(10)
	assert_eq(body.is_grounded(), false, "Body below global ground is grounded.")

func test_gravity() -> void:
	body.set_grav(1000)
	
	body.set_z_pos(-100)
	assert_eq(body.get_z_pos(), -100)
	
	gut.simulate(body, 1, 0.1)
	assert_eq(body.get_z_pos(), -90, "Gravity not applying.")
	gut.simulate(body, 1, 0.1)
	assert_eq(body.get_z_pos(), -70, "Gravity not stacking.")
	gut.simulate(body, 1, 0.1)
	assert_eq(body.get_z_pos(), -40, "Gravity not stacking.")
	gut.simulate(body, 1, 0.1)
	assert_eq(body.get_z_pos(), 0, "Gravity not stacking.")
	gut.simulate(body, 1, 0.1)
	assert_eq(body.get_z_pos(), 0, "Falls below global ground.")
	
	body.set_velocity(Vector3())
	body.set_z_pos(-100)
	gut.simulate(body, 3, 0.1)
	assert_eq(body.get_z_pos(), -40, "Gravity not stacking properly.")
	
	body.set_velocity(Vector3())
	body.set_grav(-1000)
	assert_eq(body.get_grav(), -1000)
	body.set_z_pos(-100)
	gut.simulate(body, 3, 0.1)
	assert_eq(body.get_z_pos(), -160, "Gravity not working in negative.")