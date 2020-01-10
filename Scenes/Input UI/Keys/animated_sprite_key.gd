extends AnimatedSprite

export (String) var action


func _input(event):
	if event.is_action_pressed(action):
		play("pressed")

	if event.is_action_released(action):
		play("idle")
