extends Node

enum Aim {HIGH, MID, LOW}

const LEFT = -1
const RIGHT = 1

var left_high = load("res://Sprites/Arrow Cursor/left_high.png")
var left_mid = load("res://Sprites/Arrow Cursor/left_mid.png")
var left_low = load("res://Sprites/Arrow Cursor/left_low.png")
var right_high = load("res://Sprites/Arrow Cursor/right_high.png")
var right_mid = load("res://Sprites/Arrow Cursor/right_mid.png")
var right_low = load("res://Sprites/Arrow Cursor/right_low.png")

onready var parent : LookDirection = get_parent()

var aim : int = Aim.MID
var direction : int = 1


func _physics_process(delta) -> void:
	var new_aim = parent.get_aim()
	var new_direction = parent.get_aim_direction()
	
	_set_custom_cursor(new_aim, new_direction)


func _set_custom_cursor(new_aim: int, new_direction: int) -> void:
	if new_aim == aim and new_direction == direction:
		return
	
	aim = new_aim
	direction = new_direction
	
	var image_name : String = ""
	
	if direction == LEFT:
		image_name += "left"
	elif direction == RIGHT:
		image_name += "right"
	
	image_name += "_"
	
	if aim == Aim.HIGH:
		image_name += "high"
	elif aim == Aim.MID:
		image_name += "mid"
	elif aim == Aim.LOW:
		image_name += "low"
	
	Input.set_custom_mouse_cursor(get(image_name))
