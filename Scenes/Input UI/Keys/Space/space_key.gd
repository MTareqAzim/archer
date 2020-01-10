extends Control

onready var high_jump_label = $"High Jump"

func _on_Player_state_changed(current_state):
	if current_state in ["crouch", "crouch_move", "high_jump"]:
		high_jump_label.visible = true
	elif current_state in ["fall"]:
		pass
	else:
		high_jump_label.visible = false
