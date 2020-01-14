extends AnimatedSprite

func _ready():
	pass


func _on_LookDirection_direction_changed(new_direction):
	if new_direction == 1:
		flip_h = false
		offset.x = 0
	elif new_direction == -1:
		flip_h = true
		offset.x = -24
