extends Sprite

onready var left_click = $"Left Click"
onready var right_click = $"Right Click"

func _input(event):
	if event.is_action_pressed("left_mouse"):
		left_click.visible = true
	elif event.is_action_released("left_mouse"):
		left_click.visible = false
	
	if event.is_action_pressed("right_mouse"):
		right_click.visible = true
	elif event.is_action_released("right_mouse"):
		right_click.visible = false
