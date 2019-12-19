extends "res://addons/gut/test.gd"

func before_each():
	pass

func after_each():
	for child in get_children():
		child.free()

func before_all():
	pass

func after_all():
	pass

func test_set_look_direction():
	var look_direction = LookDirection.new()
	add_child(look_direction)
	
	assert_eq(look_direction.get_look_direction(), Vector2(1, 0), "Not initialized to (1, 0).")
	
	var test_direction = Vector2(-1, -1)
	look_direction.set_look_direction(test_direction)
	assert_eq(look_direction.get_look_direction(), test_direction, "Set look direction failed.")
	
	look_direction.set_look_direction(Vector2())
	assert_ne(look_direction.get_look_direction(), Vector2(), "Look direction can't be (0, 0).")